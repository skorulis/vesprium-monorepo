// Created by Alex Skorulis on 13/4/2026.

import BioStats
import Foundation

struct BattlePlayer: Codable, Sendable, Equatable {

    let player: PlayerCharacter

    var health: Int

    init(player: PlayerCharacter) {
        self.player = player
        self.health = player.maxHealth
    }
}
