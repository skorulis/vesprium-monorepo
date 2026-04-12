//  Created by Alexander Skorulis on 7/4/2026.

import BioEnhancements
import BioStats
import Foundation
import Knit
import KnitMacros

@MainActor
struct EventGenerator {

    let mainStore: MainStore

    @Resolvable<Resolver>
    init(mainStore: MainStore) {
        self.mainStore = mainStore
    }

    /// All card kinds this generator may surface in offers (jobs, activities, body enhancements).
    static func allOfferableCards() -> [GameCard] {
        Activity.allCases.map { .activity($0) }
    }

    /// Up to four random cards from ``allOfferableCards()`` that the player does not already have.
    /// - Parameter forCompletedYear: The Vesprium calendar year that just ended (shown in ``YearEndReview``).
    func yearlyCardChoiceEvent() -> GameEvent? {
        let owned = mainStore.player.cards.allCards
        let available = Self.allOfferableCards().filter { card in
            !owned.contains(where: { $0 == card })
        }
        guard !available.isEmpty else { return nil }
        let count = min(4, available.count)
        let chosen = Array(available.shuffled().prefix(count))
        return GameEvent(
            text: "A new year begins. What new path will you explore?",
            kind: .cards(chosen),
            skippable: true
        )
    }

    func nextEvent() -> GameEvent? {
        if mainStore.gameState.currentGameDate.month.rawValue == 1 {
            return yearlyCardChoiceEvent()
        }
        return monthlyChoiceEvent()
    }

    private func randomAttributeTradeEvent() -> GameEvent? {
        let attributes = Attribute.allCases.shuffled()
        guard attributes.count >= 2 else { return nil }
        let from = attributes[0]
        let to = attributes[1]
        let available = max(0, mainStore.player.attributes[from])
        guard available > 0 else { return nil }
        let amount = min(Int.random(in: 1...3), available)
        return GameEvent(
            text: "A specialist offers to rebalance your body stats. Shift \(amount) \(from.name) into \(to.name)?",
            kind: .attributeTrade(from: from, to: to, amount: amount),
            skippable: true
        )
    }

    /// Random dilemma from ``MonthlyChoiceCatalog`` whose situation keys match the current player.
    func monthlyChoiceEvent() -> GameEvent? {
        let player = mainStore.player
        if Int.random(in: 0..<100) < 30, let trade = randomAttributeTradeEvent() {
            return trade
        }
        let matching = MonthlyChoiceCatalog.entries.filter { $0.matches(player: player) }
        guard let entry = matching.shuffled().first else { return nil }
        return GameEvent(
            text: entry.headline,
            kind: .cards([
                .monthlyChoice(entry.optionA),
                .monthlyChoice(entry.optionB),
            ]),
            skippable: true
        )
    }

}
