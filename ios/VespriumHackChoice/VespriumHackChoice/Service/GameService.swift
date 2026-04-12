import ASKCore
import BioEnhancements
import BioStats
import Combine
import Foundation
import Knit
import KnitMacros

@MainActor
final class GameService: ObservableObject {
    enum ShopPurchaseResult: Equatable {
        case purchased
        case alreadyOwned
        case insufficientFunds
    }

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
        let delta = self.executeMonthChanges(previousDate: previousDate, newDate: newDate)
        if crossedYear {
            self.refreshShopIfNeeded(forYear: newDate.year)
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
            self.appendMonthSummary(
                date: newDate,
                moneyDelta: delta,
                eventHeadline: "Year \(previousDate.year) ended — open your review.",
                choiceSummary: nil
            )
            return
        }
        let queuedEvent = self.eventGenerator.nextEvent()
        if let queuedEvent {
            state.pendingEvent = queuedEvent
            self.store.gameState = state
            self.appendMonthSummary(
                date: newDate,
                moneyDelta: delta,
                eventHeadline: queuedEvent.text,
                choiceSummary: nil
            )
        } else {
            self.appendMonthSummary(date: newDate, moneyDelta: delta, eventHeadline: nil, choiceSummary: nil)
        }
    }

    func purchaseShopEnhancement(_ enhancement: BioEnhancement) -> ShopPurchaseResult {
        var player = self.store.player
        guard player.cards.hasEnhancement(enhancement) == false else {
            return .alreadyOwned
        }

        let cost = enhancement.baseCost
        guard player.money >= cost else {
            return .insufficientFunds
        }

        player.money -= cost
        player.cards.add(card: .bodyEnhancement(enhancement))
        self.store.player = player

        var state = self.store.gameState
        state.currentYear.moneyNetChange -= cost
        self.store.gameState = state
        return .purchased
    }

    func switchJob(to job: Job) {
        var player = self.store.player
        player.cards.add(card: .job(job))
        self.store.player = player
    }

    func refreshShopIfNeeded(forYear year: Int) {
        let state = self.store.gameState
        let shouldRefresh = state.shopLastRefreshYear != year || state.shopEnhancements.isEmpty
        guard shouldRefresh else { return }
        self.refreshShop(forYear: year)
    }

    private func refreshShop(forYear year: Int) {
        var state = self.store.gameState
        let all = BioEnhancement.allCases
        let count = min(3, all.count)
        state.shopEnhancements = Array(all.shuffled().prefix(count))
        state.shopLastRefreshYear = year
        self.store.gameState = state
    }

    func resolveYearReview() {
        guard let review = self.store.gameState.pendingYearReview else { return }
        var player = self.store.player
        self.applyActivityYearlyAttributeBonuses(to: &player)
        self.store.player = player
        var state = self.store.gameState
        state.pendingYearReview = nil
        self.store.gameState = state
        if let event = self.eventGenerator.nextEvent() {
            state = self.store.gameState
            state.pendingEvent = event
            self.store.gameState = state
        }
    }

    @discardableResult
    private func executeMonthChanges(previousDate: VespriumDate, newDate: VespriumDate) -> Int {
        var player = self.store.player
        var state = self.store.gameState
        var currentYear = state.currentYear
        let delta = GameCalculator(player: player).monthlyBalanceChange()
        player.money += delta
        currentYear.moneyNetChange += delta
        state.currentYear = currentYear
        self.store.player = player
        self.store.gameState = state
        return delta
    }

    private func appendMonthSummary(
        date: VespriumDate,
        moneyDelta: Int,
        eventHeadline: String?,
        choiceSummary: String?
    ) {
        var state = self.store.gameState
        state.monthLog.append(
            MonthSummary(
                date: date,
                moneyDelta: moneyDelta,
                eventHeadline: eventHeadline,
                choiceSummary: choiceSummary
            )
        )
        if state.monthLog.count > 48 {
            state.monthLog.removeFirst(state.monthLog.count - 48)
        }
        self.store.gameState = state
    }

    private func recordChoiceOnLastMonthSummary(_ label: String) {
        var state = self.store.gameState
        guard !state.monthLog.isEmpty else { return }
        let index = state.monthLog.count - 1
        state.monthLog[index].choiceSummary = label
        self.store.gameState = state
    }

    private func applyMonthlyChoiceEffect(_ effect: MonthlyChoiceEffect) {
        var player = self.store.player
        var state = self.store.gameState
        var currentYear = state.currentYear
        switch effect {
        case .moneyDelta(let amount):
            player.money += amount
            currentYear.moneyNetChange += amount
        case .vitalityDelta(let amount):
            player.attributes[.vitality] = max(0, player.attributes[.vitality] + amount)
            if amount != 0 {
                currentYear.attributeIncreases[.vitality, default: 0] += amount
            }
        case .attributeDelta(let attribute, let amount):
            player.attributes[attribute] += amount
            if amount > 0 {
                currentYear.attributeIncreases[attribute, default: 0] += amount
            }
        case .payTuition(let cost, let attribute, let amount):
            player.money -= cost
            currentYear.moneyNetChange -= cost
            player.attributes[attribute] += amount
            if amount > 0 {
                currentYear.attributeIncreases[attribute, default: 0] += amount
            }
        case .riskMoneyOrVitality(let moneyIfSuccess, let vitalityLossIfFail, let successPercent):
            if Chance(percent: successPercent).check() {
                player.money += moneyIfSuccess
                currentYear.moneyNetChange += moneyIfSuccess
            } else {
                player.attributes[.vitality] = max(0, player.attributes[.vitality] - vitalityLossIfFail)
                currentYear.attributeIncreases[.vitality, default: 0] -= vitalityLossIfFail
            }
        }
        self.store.player = player
        state.currentYear = currentYear
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
        if let card {
            switch card {
            case .monthlyChoice(let option):
                self.applyMonthlyChoiceEffect(option.effect)
                self.recordChoiceOnLastMonthSummary(option.title)
            default:
                let price = card.price
                var player = store.player
                player.money -= price
                player.cards.add(card: card)
                store.player = player
                var state = store.gameState
                state.currentYear.moneyNetChange -= price
                store.gameState = state
                self.recordChoiceOnLastMonthSummary(card.name)
            }
        } else {
            guard event.skippable else { return }
            self.recordChoiceOnLastMonthSummary("Skipped")
        }
        var state = store.gameState
        state.pendingEvent = nil
        store.gameState = state
    }
}
