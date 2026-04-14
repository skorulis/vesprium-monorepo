//  Created by Alex Skorulis on 13/4/2026.

import BioStats
import BioEnhancements
import Foundation

/// The player character that has a life cycle of an entire game
struct PlayerCharacter: Codable, Sendable, Equatable {
    var attributes: AttributeValues = .init()
    var enhancements: EnhancementValues = .init()
    var money: Int = 100

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

    var mentalAbilities: [MentalAbility] {
        return [.focusSpike]
    }
    
    var maxPhysicalBurnout: Int {
        max(effectiveAttributes[.vitality] - enhancements.strain.physical, 1)
    }
    
    var maxMentalBurnout: Int {
        max(effectiveAttributes[.stability] - enhancements.strain.mental, 1)
    }
}
