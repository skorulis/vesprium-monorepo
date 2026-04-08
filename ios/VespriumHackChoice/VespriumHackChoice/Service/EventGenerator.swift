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
            cards: chosen,
            skippable: true
        )
    }

    func nextEvent() -> GameEvent? {
        if mainStore.player.job == nil {
            return firstJobOfferEvent()
        }
        if mainStore.player.cards.activities.isEmpty {
            return activityChoiceEvent()
        }
        return nil
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
