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

    func makeBattle(level: Int) -> Battle {
        let battlePlayer = BattlePlayer(player: mainStore.player)
        return Battle(
            level: level,
            enemyCount: 4 + level,
            battlePlayer: battlePlayer,
        )
    }

    /// The player attacks
    func playerTick(time: TimeInterval, battle: inout Battle) {
        battle.battlePlayer.storedTime += time
        battle.battlePlayer.storedTime = min(1, battle.battlePlayer.storedTime)
        updateAbilityCooldowns(battlePlayer: &battle.battlePlayer, time: time)
        maybePlayerAttack(battle: &battle)
    }

    func updateAbilityCooldowns(battlePlayer: inout BattlePlayer, time: TimeInterval) {
        let active = battlePlayer.activeAbilities
        for (ability, remaining) in active {
            let next = max(0, remaining - time)
            if next == 0 {
                battlePlayer.activeAbilities.removeValue(forKey: ability)
            } else {
                battlePlayer.activeAbilities[ability] = next
            }
        }
    }

    private func maybePlayerAttack(battle: inout Battle) {
        guard let targetEnemyID = battle.resolvedTargetEnemyID(),
              var enemy = battle.enemies.first(where: { $0.id == targetEnemyID }) else { return }
        guard battle.battlePlayer.storedTime >= 1 else { return }
        battle.battlePlayer.storedTime -= 1
        let details = enemy.details

        let hitChance = calculator.hitChance(
            attackerAgility: battle.battlePlayer.agility,
            defenderAgility: details.agility
        )
        guard hitChance.check() else {
            print("Miss")
            return
        }

        enemy.health -= battle.battlePlayer.damage
        battle.replace(enemy: enemy)
        if enemy.health <= 0 {
            mainStore.player.addMoney(details.money)
            print("Killed \(enemy.kind.rawValue)")
        }
    }

    /// An enemy attacks
    func enemyTick(battle: inout Battle, enemy: inout Enemy, time: TimeInterval) {
        enemy.storedTime += time
        let details = enemy.details
        guard enemy.storedTime >= details.attackRate else { return }
        enemy.storedTime -= details.attackRate

        let hitChance = calculator.hitChance(
            attackerAgility: details.agility,
            defenderAgility: battle.battlePlayer.agility
        )

        guard hitChance.check() else { return }
        let damage = (details.damage - battle.battlePlayer.player.damageAbsorbtion)
        battle.battlePlayer.health -= damage
        battle.battlePlayer.health = max(battle.battlePlayer.health, 0)
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
