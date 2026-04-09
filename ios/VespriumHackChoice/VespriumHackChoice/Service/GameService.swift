import ASKCore
import BioStats
import Combine
import Foundation
import Knit
import KnitMacros

@MainActor
final class GameService: ObservableObject {
    private let store: MainStore
    private let eventGenerator: EventGenerator

    @Resolvable<Resolver>
    init(store: MainStore, eventGenerator: EventGenerator) {
        self.store = store
        self.eventGenerator = eventGenerator
    }

    func advanceTime() {
        var state = self.store.gameState
        let previousDate = state.currentGameDate
        let newDate = previousDate.adding(months: 1)
        let crossedYear = previousDate.year != newDate.year
        state.currentGameDate = newDate
        self.store.gameState = state
        self.executeMonthChanges(previousDate: previousDate, newDate: newDate)
        if crossedYear {
            self.applyYearlyWeaknessCheck(on: newDate)
            state = self.store.gameState
            var reviewTotals = state.currentYear
            self.mergeActivityYearlyBonuses(into: &reviewTotals, player: self.store.player)
            state.pendingYearReview = YearEndReview(year: previousDate.year, totals: reviewTotals)
            state.currentYear = .zero
            self.store.gameState = state
        }
        state = self.store.gameState
        if state.pendingYearReview != nil {
            return
        }
        if let event = self.eventGenerator.nextEvent() {
            state.pendingEvent = event
            self.store.gameState = state
        }
    }

    func resolveYearReview() {
        guard self.store.gameState.pendingYearReview != nil else { return }
        var player = self.store.player
        self.applyActivityYearlyAttributeBonuses(to: &player)
        self.store.player = player
        var state = self.store.gameState
        state.pendingYearReview = nil
        self.store.gameState = state
        if let yearly = self.eventGenerator.yearlyCardChoiceEvent() {
            state = self.store.gameState
            state.pendingEvent = yearly
            self.store.gameState = state
        } else if let event = self.eventGenerator.nextEvent() {
            state = self.store.gameState
            state.pendingEvent = event
            self.store.gameState = state
        }
    }

    private func executeMonthChanges(previousDate: VespriumDate, newDate: VespriumDate) {
        var player = self.store.player
        var state = self.store.gameState
        var currentYear = state.currentYear
        let delta = GameCalculator(player: player).monthlyBalanceChange()
        player.money += delta
        currentYear.moneyNetChange += delta
        state.currentYear = currentYear
        self.store.player = player
        self.store.gameState = state
    }

    private func activityYearlyAttributeIncreases(for player: PlayerCharacter) -> [Attribute: Int] {
        var result: [Attribute: Int] = [:]
        for card in player.cards.activities {
            guard case .activity(let activity) = card else { continue }
            for (attribute, delta) in activity.details.yearlyAttributeBonuses where delta != 0 {
                result[attribute, default: 0] += delta
            }
        }
        return result
    }

    private func mergeActivityYearlyBonuses(into totals: inout CurrentYear, player: PlayerCharacter) {
        for (attribute, amount) in self.activityYearlyAttributeIncreases(for: player) where amount > 0 {
            totals.attributeIncreases[attribute, default: 0] += amount
        }
    }

    private func applyActivityYearlyAttributeBonuses(to player: inout PlayerCharacter) {
        for (attribute, amount) in self.activityYearlyAttributeIncreases(for: player) {
            player.attributes[attribute] += amount
        }
    }

    /// At each year boundary, roll against the player's weakness chance.
    /// A failed roll reduces vitality by 1.
    private func applyYearlyWeaknessCheck(on currentGameDate: VespriumDate) {
        var player = self.store.player
        let weakness = GameCalculator(player: player).weaknessChance(on: currentGameDate)
        let survivesYear = Chance(percent: weakness).check()
        guard survivesYear == false else { return }
        player.attributes[.vitality] = max(0, player.attributes[.vitality] - 1)
        self.store.player = player

        var state = self.store.gameState
        state.currentYear.attributeIncreases[.vitality, default: 0] -= 1
        self.store.gameState = state
    }

    func resolvePendingEvent(selecting card: GameCard?) {
        guard let event = store.gameState.pendingEvent else { return }
        var state = store.gameState
        if let card {
            let price = card.price
            var player = store.player
            player.money -= price
            player.cards.add(card: card)
            store.player = player
            state.currentYear.moneyNetChange -= price
        } else {
            guard event.skippable else { return }
        }

        state.pendingEvent = nil
        store.gameState = state
    }
}
