//  Created by Alex Skorulis on 8/4/2026.

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
    @MainActor
    func monthlyJobEarnings(for job: Job) -> Int {
        monthlyJobEarnings(for: job, attributes: mainStore.player.attributes)
    }

    func monthlyJobEarnings(for job: Job, attributes: AttributeValues) -> Int {
        let fromAttributes = job.incomeBonuses.reduce(0) { total, entry in
            total + entry.value * attributes[entry.key]
        }
        return job.monthlyIncome + fromAttributes
    }
}
