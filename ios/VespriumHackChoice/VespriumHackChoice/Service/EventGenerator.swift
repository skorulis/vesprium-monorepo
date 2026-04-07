//  Created by Alexander Skorulis on 7/4/2026.

import Foundation
import Knit
import KnitMacros

struct EventGenerator {

    let mainStore: MainStore

    @Resolvable<Resolver>
    init(mainStore: MainStore) {
        self.mainStore = mainStore
    }

    /// Offer shown when the player has no job after a month advances.
    func firstJobOfferEvent() -> GameEvent {
        GameEvent(
            text: "Word spreads that you are looking for work. Local employers have openings.",
            cards: Job.allCases.map { GameCard.job($0) },
            skippable: false
        )
    }
}
