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

    /// Total mental burnout
    var mentalBurnout: Burnout = .init()

    var mentalBurnoutFraction: Double {
        return mentalBurnout.total / Double(player.maxMentalBurnout)
    }

    var physicalBurnout: Burnout = .init()

    var physicalBurnoutFraction: Double {
        return physicalBurnout.total / Double(player.maxPhysicalBurnout)
    }

    var maxExertionFraction: Double {
        return Double(player.maxExertion) / 100
    }

    /// Time until the ability is available
    var abilityCooldowns: [MentalAbility: Double] = [:]

    /// Abilities that are active
    var activeAbilities: [MentalAbility: Double] = [:]

    var derivedAttributeBonuses: [DerivedAttributeBonus] {
        return player.enhancements.derivedAttributeBonuses
            + activeAbilities.keys.flatMap { $0.derivedAttributeBonuses }
    }

    var attributeBonuses: [AttributeBonus] {
        return player.enhancements.attributeBonuses // + activeAbilities.keys.flatMap(\.attributeBonuses)
    }

    init(player: PlayerCharacter) {
        self.player = player
        self.health = player.maxHealth
    }

    var agility: Int {
        let base = player.effectiveAttributes[.agility]
        return AttributeBonus.adjustedValue(
            base: base,
            bonuses: attributeBonuses,
            attribute: .agility
        )
    }

    var damage: Int {
        let base = player.effectiveAttributes[.strength] / 2
        return DerivedAttributeBonus.adjustedValue(
            base: base,
            bonuses: derivedAttributeBonuses,
            attribute: .damage
        )
    }

    mutating func activate(ability: MentalAbility) {
        abilityCooldowns[ability] = ability.cooldown
        activeAbilities[ability] = ability.duration
        mentalBurnout.total += Double(ability.strain.mental)
        physicalBurnout.total += Double(ability.strain.physical)
    }

    mutating func updateExertion(time: TimeInterval) {

        physicalBurnout.total -= time
        physicalBurnout.total = max(physicalBurnout.total, Double(player.enhancements.strain.physical))

        if physicalBurnoutFraction > 1 {
            physicalBurnout.decayChance += physicalBurnoutFraction * time * 0.25
        } else {
            physicalBurnout.decayChance = 0
        }

        mentalBurnout.total -= time
        mentalBurnout.total = max(mentalBurnout.total, Double(player.enhancements.strain.mental))
        
        if mentalBurnoutFraction > 1 {
            mentalBurnout.decayChance += mentalBurnoutFraction * time * 0.25
        } else {
            mentalBurnout.decayChance = 0
        }
    }

}

struct Burnout: Codable, Equatable, Sendable {
    var total: Double = 0
    var decayChance: Double = 0

}
