// Created by Alex Skorulis on 13/4/2026.

import Knit
import KnitMacros
import Foundation
import Util

final class BattleService {

    private let mainStore: MainStore
    private let enemyService: EnemyService
    private let calculator = BattleCalculator()

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
    func playerTick(time: TimeInterval, battle: inout Battle) {
        battle.battlePlayer.storedTime += time
        maybePlayerAttack(battle: &battle)
    }

    private func maybePlayerAttack(battle: inout Battle) {
        guard var enemy = battle.enemies.first else { return }
        guard battle.battlePlayer.storedTime >= 1 else { return }
        battle.battlePlayer.storedTime -= 1

        let hitChance = calculator.hitChance(
            attackerAgility: battle.battlePlayer.player.agility,
            defenderAgility: enemy.kind.agility
        )
        guard hitChance.check() else {
            print("Miss")
            return
        }

        let damage = Double(battle.battlePlayer.player.damage) * battle.battlePlayer.averagedPhysicalExertion

        enemy.health -= Int(round(damage))
        battle.replace(enemy: enemy)
        if enemy.health <= 0 {
            mainStore.player.money += enemy.kind.money
            print("Killed \(enemy.kind.rawValue)")
        }
    }

    /// An enemy attacks
    func enemyTick(battle: inout Battle, enemy: Enemy) {
        let hitChance = calculator.hitChance(
            attackerAgility: enemy.kind.agility,
            defenderAgility: battle.battlePlayer.player.agility
        )
        
        guard hitChance.check() else { return }
        battle.battlePlayer.health -= enemy.kind.damage
    }

    /// Spawn enemies if needed
    func battleTick(battle: inout Battle) {
        battle.time += 1
        maybeSpawn(battle: &battle)

    }

    private func maybeSpawn(battle: inout Battle) {
        guard battle.enemiesRemaining > 0 else { return }

        let spawnChancePercent = if battle.spawnedEnemies == 0 {
            100
        } else {
            40 - (battle.enemies.count * 10)
        }

        let chance = Chance(percent: spawnChancePercent)
        guard chance.check() else { return }
        let enemy = enemyService.make(battleLevel: battle.level)
        battle.enemies.append(enemy)
        print("Spawned \(enemy.kind.rawValue)")
    }
}
