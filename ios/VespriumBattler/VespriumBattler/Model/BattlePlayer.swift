// Created by Alex Skorulis on 13/4/2026.

import BioEnhancements
import BioStats
import Foundation

struct BattlePlayer: Codable, Sendable, Equatable {

    var player: PlayerCharacter

    /// Current health
    var health: Int

    /// Time that has accumulated in order to perform the next attack
    var storedTime: Double = 0

    /// Exertion averaged over time to prevent quick changes
    var averagedPhysicalExertion: Double = 0

    /// Total mental burnout
    var mentalBurnout: Double = 0

    var mentalBurnoutFraction: Double {
        return mentalBurnout / Double(player.maxMentalBurnout)
    }

    var physicalBurnout: Burnout = .init()

    var physicalBurnoutFraction: Double {
        return physicalBurnout.total / Double(player.maxPhysicalBurnout)
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

    var damage: Int {
        let value = Double(player.damage) * averagedPhysicalExertion
        return Int(round(value))
    }

    mutating func activate(ability: MentalAbility) {
        abilityCooldowns[ability] = ability.cooldown
        activeAbilities[ability] = ability.duration
        mentalBurnout += Double(ability.mentalLoad)
    }

    mutating func updateExertion(physical: Double, time: TimeInterval) {
        averagedPhysicalExertion = averagedPhysicalExertion * (1 - time) + physical * time

        physicalBurnout.total += burnoutChange * time
        physicalBurnout.total = max(physicalBurnout.total, 0)
        physicalBurnout.total = min(physicalBurnout.total, Double(player.maxPhysicalBurnout))

        if physicalBurnoutFraction >= 0.9 {
            physicalBurnout.decayChance += physicalBurnoutFraction * time * 0.25
        } else {
            physicalBurnout.decayChance = 0
        }

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

struct Burnout: Codable, Equatable, Sendable {
    var total: Double = 0
    var decayChance: Double = 0

}
