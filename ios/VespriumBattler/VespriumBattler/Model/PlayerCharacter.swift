//  Created by Alex Skorulis on 13/4/2026.

import BioStats
import BioEnhancements
import Foundation

/// The player character that has a life cycle of an entire game
struct PlayerCharacter: Codable, Sendable, Equatable {
    var attributes: AttributeValues = .init()
    var enhancements: EnhancementValues = .init()

    init() {}

    var maxHealth: Int { effectiveAttributes[.vitality] * 3 }

    var effectiveAttributes: AttributeValues {
        attributes.applyingBonuses(enhancements.attributeBonuses)
    }
}
