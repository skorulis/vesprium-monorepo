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
            state = self.store.gameState
            state.pendingYearReview = YearEndReview(year: previousDate.year, totals: state.currentYear)
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
        self.applyActivityYearlyAttributeBonuses(
            player: &player,
            currentYear: &currentYear,
            previousDate: previousDate,
            newDate: newDate
        )
        let delta = GameCalculator(player: player).monthlyBalanceChange()
        player.money += delta
        currentYear.moneyNetChange += delta
        state.currentYear = currentYear
        self.store.player = player
        self.store.gameState = state
    }

    /// Full Vesprium calendar years completed since `start` relative to `current`
    /// (same rules as ``PlayerCharacter/ageInFullYears``).
    private func fullCalendarYearsHeld(since start: VespriumDate, on current: VespriumDate) -> Int {
        guard current >= start else { return 0 }
        var years = current.year - start.year
        let startMonth = start.month.rawValue
        let nowMonth = current.month.rawValue
        if nowMonth < startMonth
            || (nowMonth == startMonth && current.day < start.day) {
            years -= 1
        }
        return max(0, years)
    }

    private func applyActivityYearlyAttributeBonuses(
        player: inout PlayerCharacter,
        currentYear: inout CurrentYear,
        previousDate: VespriumDate,
        newDate: VespriumDate
    ) {
        for instance in player.cards.activities {
            guard case .activity(let activity) = instance.card else { continue }
            let bonuses = activity.details.yearlyAttributeBonuses
            if bonuses.isEmpty { continue }
            let before = fullCalendarYearsHeld(since: instance.date, on: previousDate)
            let after = fullCalendarYearsHeld(since: instance.date, on: newDate)
            let steps = after - before
            guard steps > 0 else { continue }
            for (attribute, deltaPerYear) in bonuses {
                let amount = deltaPerYear * steps
                player.attributes[attribute] += amount
                if amount > 0 {
                    currentYear.attributeIncreases[attribute, default: 0] += amount
                }
            }
        }
    }

    func resolvePendingEvent(selecting card: GameCard?) {
        guard let event = store.gameState.pendingEvent else { return }
        if let card {
            var player = store.player
            player.cards.add(card: card, on: store.gameState.currentGameDate)
            store.player = player
        } else {
            guard event.skippable else { return }
        }
        var state = store.gameState
        state.pendingEvent = nil
        store.gameState = state
    }
}
