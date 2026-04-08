//  Created by Alex Skorulis on 8/4/2026.

import Foundation
import Knit
import KnitMacros

struct CalculationsService {

    let mainStore: MainStore

    @Resolvable<Resolver>
    init(mainStore: MainStore) {
        self.mainStore = mainStore
    }

    @MainActor
    func monthlyJobEarnings(for job: Job) -> Int {
        GameCalculator(player: mainStore.player).monthlyJobEarnings(for: job)
    }

    @MainActor
    func monthlyBalanceChange() -> Int {
        GameCalculator(player: mainStore.player).monthlyBalanceChange()
    }
}
