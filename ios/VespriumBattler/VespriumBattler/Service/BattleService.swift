// Created by Alex Skorulis on 13/4/2026.

import Knit
import KnitMacros
import Foundation
import Util

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
        // TODO: Implement player attack on the first enemy
        print("Player tick")
    }

    /// An enemy attacks
    func enemyTick(battle: inout Battle, enemy: Enemy) {
        // TODO: Implement enemy attack on the player
        print("Enemy tick")
    }

    /// Spawn enemies if needed
    func battleTick(battle: inout Battle) {
        guard battle.enemiesRemaining > 0 else { return }
        
        let spawnChancePercent = if battle.spawnedEnemies == 0 {
            100
        } else {
            20 - (battle.enemies.count * 5)
        }
        
        let chance = Chance(percent: spawnChancePercent)
        guard chance.check() else { return }
        let enemy = enemyService.make(battleLevel: battle.level)
        battle.enemies.append(enemy)
        print("Spawned \(enemy.kind.rawValue)")
    }
}
