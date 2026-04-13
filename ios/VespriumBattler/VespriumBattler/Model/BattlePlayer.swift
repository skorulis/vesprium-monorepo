// Created by Alex Skorulis on 13/4/2026.

import BioStats
import Foundation

struct BattlePlayer: Codable, Sendable, Equatable {

    let player: PlayerCharacter

    var health: Int

    /// Time that has accumulated in order to perform the next attack
    var storedTime: Double = 0

    /// Exertion averaged over time to prevent quick changes
    var averagedPhysicalExertion: Double = 1

    /// Current burnout level
    var physicalBurnout: Double = 0

    init(player: PlayerCharacter) {
        self.player = player
        self.health = player.maxHealth
    }

    mutating func updateExertion(physical: Double, time: TimeInterval) {
        averagedPhysicalExertion = averagedPhysicalExertion * (1 - time) + physical * time
        physicalBurnout = physicalBurnout * (1 - time) + averagedPhysicalExertion * time
        physicalBurnout = min(physicalBurnout, 1)
    }
}
