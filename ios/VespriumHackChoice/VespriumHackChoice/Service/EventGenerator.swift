//  Created by Alexander Skorulis on 7/4/2026.

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
