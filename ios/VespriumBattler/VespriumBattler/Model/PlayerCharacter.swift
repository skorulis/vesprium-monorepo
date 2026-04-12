//  Created by Alex Skorulis on 13/4/2026.

import BioStats
import BioEnhancements
import Foundation

struct PlayerCharacter: Codable, Sendable, Equatable {
    var health: Int
    var attributes: AttributeValues = .init()
    var enhancements: EnhancementValues = .init()

    init() {
        self.health = 0
        resetForBattle()
    }

    var maxHealth: Int { attributes[.vitality] * 3 }

    mutating func resetForBattle() {
        self.health = maxHealth
    }

    var effectiveAttributes: AttributeValues {
        attributes.applyingBonuses(enhancements.attributeBonuses)
    }
}
