//  Created by Alex Skorulis on 8/4/2026.

import BioEnhancements
import BioStats
import Foundation
import Knit
import KnitMacros

struct CalculationsService {

    let mainStore: MainStore

    @Resolvable<Resolver>
    init(mainStore: MainStore) {
        self.mainStore = mainStore
    }

    /// Monthly coins from a job: base ``Job/monthlyIncome`` plus each ``Job/incomeBonuses`` entry
    /// (`coefficient ×` current value for that ``Attribute``).
    ///
    /// Farming only: if the player has ``BioEnhancement/barometricEars``, the result is 50% higher
    /// (×1.5, rounded down).
    @MainActor
    func monthlyJobEarnings(for job: Job) -> Int {
        monthlyJobEarnings(for: job, attributes: mainStore.player.attributes, cards: mainStore.player.cards)
    }

    func monthlyJobEarnings(for job: Job, attributes: AttributeValues, cards: PlayerCards = PlayerCards()) -> Int {
        let fromAttributes = job.incomeBonuses.reduce(0) { total, entry in
            total + entry.value * attributes[entry.key]
        }
        var total = job.monthlyIncome + fromAttributes
        if job == .farming, cards.hasEnhancement(.barometricEars) {
            total = (total * 3) / 2
        }
        return total
    }
}
