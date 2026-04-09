//  Created by Alexander Skorulis on 7/4/2026.

import BioEnhancements
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
        Job.allCases.map { .job($0) }
            + Activity.allCases.map { .activity($0) }
            + BioEnhancement.allCases.map { .bodyEnhancement($0) }
    }

    /// Up to four random cards from ``allOfferableCards()`` that the player does not already have.
    /// - Parameter forCompletedYear: The Vesprium calendar year that just ended (shown in ``YearEndReview``).
    func yearlyCardChoiceEvent(forCompletedYear year: Int) -> GameEvent? {
        guard Self.shouldOfferYearlyCardChoice(forCompletedYear: year) else { return nil }
        let owned = mainStore.player.cards.allCards
        let available = Self.allOfferableCards().filter { card in
            !owned.contains(where: { $0 == card })
        }
        guard !available.isEmpty else { return nil }
        let count = min(4, available.count)
        let chosen = Array(available.shuffled().prefix(count))
        return GameEvent(
            text: "A new year begins. What new path will you explore?",
            cards: chosen,
            skippable: true
        )
    }

    /// Yearly card pick is offered on **odd** completed years only (e.g. 1251, 1253) to keep the milestone rarer.
    static func shouldOfferYearlyCardChoice(forCompletedYear year: Int) -> Bool {
        year % 2 == 1
    }

    func nextEvent() -> GameEvent? {
        if mainStore.player.job == nil {
            return firstJobOfferEvent()
        }
        if mainStore.player.cards.activities.isEmpty {
            return activityChoiceEvent()
        }
        return monthlyChoiceEvent()
    }

    /// Random dilemma from ``MonthlyChoiceCatalog`` whose situation keys match the current player.
    func monthlyChoiceEvent() -> GameEvent? {
        let player = mainStore.player
        let matching = MonthlyChoiceCatalog.entries.filter { $0.matches(player: player) }
        guard let entry = matching.shuffled().first else { return nil }
        return GameEvent(
            text: entry.headline,
            cards: [
                .monthlyChoice(entry.optionA),
                .monthlyChoice(entry.optionB)
            ],
            skippable: true
        )
    }

    /// Offer shown when the player has no job after a month advances.
    private func firstJobOfferEvent() -> GameEvent {
        GameEvent(
            text: "Word spreads that you are looking for work. Local employers have openings.",
            cards: Job.allCases.map { GameCard.job($0) },
            skippable: false
        )
    }

    /// Shown once the player is employed but has not chosen an outside-work activity yet.
    private func activityChoiceEvent() -> GameEvent {
        GameEvent(
            text: "You have some free time outside work. What will you focus on?",
            cards: Activity.allCases.map { GameCard.activity($0) },
            skippable: false
        )
    }
}
