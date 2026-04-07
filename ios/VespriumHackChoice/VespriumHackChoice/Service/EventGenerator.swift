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
}
