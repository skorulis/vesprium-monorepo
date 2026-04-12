// Created by Alex Skorulis on 13/4/2026.

import Foundation
import Knit
import KnitMacros

@MainActor @Observable final class BattleViewModel {

    private let battleService: BattleService
    private let mainStore: MainStore

    private var model: BattleView.Model

    @Resolvable<Resolver>
    init(battleService: BattleService, mainStore: MainStore) {
        self.battleService = battleService
        self.mainStore = mainStore

        let battle = battleService.makeBattle()
        self.model = .init(battle: battle)
    }
}
