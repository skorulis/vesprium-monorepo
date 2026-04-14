// Created by Alex Skorulis on 13/4/2026.

import Foundation

struct Battle: Codable, Sendable, Equatable {
    /// The level of the battle for enemy scaling
    let level: Int

    /// How many enemies will be part of this battle
    let enemyCount: Int

    /// How many seconds this battle has been going on for
    var time: Int = 0

    /// The player currently in battle
    var battlePlayer: BattlePlayer

    /// The current enemies in the battle
    var enemies: [Enemy] = []

    /// The enemy currently targeted by the player
    var targetedEnemyID: UUID?

    /// Enemies that have been killed by the player
    var defeatedEnemies: [Enemy] = []

    /// How many enemies to defeat before the battle is finished
    var enemiesRemaining: Int { enemyCount - defeatedEnemies.count - enemies.count }
    var spawnedEnemies: Int { enemies.count + defeatedEnemies.count }

    mutating func replace(enemy: Enemy) {
        guard let index = enemies.firstIndex(where: { $0.id == enemy.id}) else { return }
        if enemy.health <= 0 {
            enemies.remove(at: index)
            if targetedEnemyID == enemy.id {
                targetedEnemyID = nil
            }
            defeatedEnemies.append(enemy)
        } else {
            enemies[index] = enemy
        }
    }

    /// Returns the currently targeted enemy ID, falling back to first alive enemy.
    mutating func resolvedTargetEnemyID() -> UUID? {
        if let targetedEnemyID, enemies.contains(where: { $0.id == targetedEnemyID }) {
            return targetedEnemyID
        }
        targetedEnemyID = enemies.first?.id
        return targetedEnemyID
    }

    var state: BattleState {
        if battlePlayer.health <= 0 {
            return .lost
        }
        if enemies.count == 0 && enemiesRemaining == 0 {
            return .won
        }
        return .ongoing
    }
}

enum BattleState {
    case ongoing, won, lost
}
