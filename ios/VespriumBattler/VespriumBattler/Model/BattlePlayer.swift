// Created by Alex Skorulis on 13/4/2026.

import BioStats
import Foundation

struct BattlePlayer: Codable, Sendable, Equatable {

    let player: PlayerCharacter

    var health: Int
    
    /// Time that has accumulated in order to perform the next attack
    var storedTime: Double = 0

    init(player: PlayerCharacter) {
        self.player = player
        self.health = player.maxHealth
    }
}
