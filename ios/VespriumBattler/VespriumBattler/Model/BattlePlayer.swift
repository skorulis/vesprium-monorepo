// Created by Alex Skorulis on 13/4/2026.

import BioStats
import Foundation

struct BattlePlayer: Codable, Sendable, Equatable {

    let player: PlayerCharacter

    /// Current health
    var health: Int

    /// Time that has accumulated in order to perform the next attack
    var storedTime: Double = 0

    /// Exertion averaged over time to prevent quick changes
    var averagedPhysicalExertion: Double = 0

    /// Total mental burnout
    var mentalBurnout: Double = 0

    var mentalBurnoutFraction: Double {
        return mentalBurnout / Double(player.effectiveAttributes[.stability])
    }

    /// Total physical burnout
    var physicalBurnout: Double = 0

    var physicalBurnoutFraction: Double {
        return physicalBurnout / Double(player.effectiveAttributes[.vitality])
    }

    /// Time until the ability is available
    var abilityCooldowns: [MentalAbility: Double] = [:]

    /// Abilities that are active
    var activeAbilities: [MentalAbility: Double] = [:]

    init(player: PlayerCharacter) {
        self.player = player
        self.health = player.maxHealth
    }
    
    var agility: Int {
        let value = Double(player.effectiveAttributes[.agility]) * averagedPhysicalExertion
        return Int(round(value))
    }

    mutating func activate(ability: MentalAbility) {
        abilityCooldowns[ability] = ability.cooldown
        activeAbilities[ability] = ability.duration
        mentalBurnout += Double(ability.mentalLoad)
    }

    mutating func updateExertion(physical: Double, time: TimeInterval) {
        averagedPhysicalExertion = averagedPhysicalExertion * (1 - time) + physical * time

        physicalBurnout += burnoutChange * time
        physicalBurnout = max(physicalBurnout, 0)
        physicalBurnout = min(physicalBurnout, Double(player.effectiveAttributes[.vitality]))

        mentalBurnout -= time
        mentalBurnout = max(mentalBurnout, 0)
    }

    var burnoutChange: Double {
        let burnoutCutoff = 0.8
        if averagedPhysicalExertion > burnoutCutoff {
            return (averagedPhysicalExertion - burnoutCutoff) / (1 - burnoutCutoff)
        } else {
            return -(burnoutCutoff - averagedPhysicalExertion) / burnoutCutoff
        }
    }
}
