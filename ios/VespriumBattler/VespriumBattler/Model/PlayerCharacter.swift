//  Created by Alex Skorulis on 13/4/2026.

import BioStats
import BioEnhancements
import Foundation

/// The player character that has a life cycle of an entire game
struct PlayerCharacter: Codable, Sendable, Equatable {
    var attributes: AttributeValues = .init()
    var enhancements: EnhancementValues = .init()
    var money: Int = 0

    init() {}

    var maxHealth: Int { effectiveAttributes[.vitality] * 3 }

    var effectiveAttributes: AttributeValues {
        attributes.applyingBonuses(enhancements.attributeBonuses)
    }

    var damage: Int {
        let base = effectiveAttributes[.strength] / 2
        return DerivedAttributeBonus.adjustedValue(
            base: base,
            bonuses: enhancements.derivedAttributeBonuses,
            attribute: .damage
        )
    }

    var damageAbsorbtion: Int {
        return DerivedAttributeBonus.adjustedValue(
            base: 0,
            bonuses: enhancements.derivedAttributeBonuses,
            attribute: .damageAbsorbtion
        )
    }

    var mentalAbilities: [MentalAbility] {
        return [.hardPush, .focusSpike]
    }

    var maxPhysicalBurnout: Int {
        effectiveAttributes[.vitality]
    }

    var maxMentalBurnout: Int {
        effectiveAttributes[.stability]
    }

    var maxExertion: Int {
        return DerivedAttributeBonus.adjustedValue(
            base: 100,
            bonuses: enhancements.derivedAttributeBonuses,
            attribute: .maxPhysicalExertion
        )
    }

    mutating func addMoney(_ amount: Int) {
        let total = Double(amount) * rewardMoneyMultiplier
        money += Int(round(total))
    }

    // How much extra money is gained from rewards
    var rewardMoneyMultiplier: Double {
        let base = effectiveAttributes[.charisma] - Attribute.defaultValue
        return 1 + (0.05 * Double(base))
    }

}
