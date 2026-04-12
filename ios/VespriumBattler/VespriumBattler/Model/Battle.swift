// Created by Alex Skorulis on 13/4/2026.

import Foundation

struct Battle: Codable, Sendable, Equatable {
    /// The level of the battle for enemy scaling
    let level: Int

    /// How many enemies will be part of this battle
    let enemyCount: Int

    /// How many seconds this battle has been going on for
    var time: Int = 0

    /// How many enemies to defeat before the battle is finished
    var enemiesRemaining: Int { enemyCount - defeatedEnemies.count }

    /// The player currently in battle
    var battlePlayer: BattlePlayer

    /// The current enemies in the battle
    var enemies: [Enemy] = []

    /// Enemies that have been killed by the player
    var defeatedEnemies: [Enemy] = []

}
