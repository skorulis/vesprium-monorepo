// Created by Alex Skorulis on 13/4/2026.

import Knit
import KnitMacros
import Foundation

final class BattleService {

    private let mainStore: MainStore
    private let enemyService: EnemyService

    @Resolvable<Resolver>
    init(mainStore: MainStore, enemyService: EnemyService) {
        self.mainStore = mainStore
        self.enemyService = enemyService
    }

    func makeBattle() -> Battle {
        let battlePlayer = BattlePlayer(player: mainStore.player)
        return Battle(
            level: 1,
            enemyCount: 5,
            battlePlayer: battlePlayer,
        )
    }

    /// The player attacks
    func playerTick(battle: inout Battle) {

    }

    /// An enemy attacks
    func enemyTick(battle: inout Battle, enemy: Enemy) {

    }

    /// Spawn enemies if needed
    func battleTick(battle: inout Battle) {

    }
}
