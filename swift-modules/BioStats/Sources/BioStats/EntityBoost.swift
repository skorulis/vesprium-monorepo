//  Created by Alex Skorulis on 15/4/2026.

import Foundation

/// Some object which gives a boost to the entity that is using it
public protocol EntityBoost {

    var id: String { get }

    /// The name of the boost
    var name: String { get }

    /// Text to explain what this is
    var text: String { get }

    /// Attribute bonuses
    var attributeBonuses: [AttributeBonus] { get }

    /// Derived attribute bonuses
    var derivedAttributeBonuses: [DerivedAttributeBonus] { get }

    /// Body strain
    var strain: Strain { get }

}

public extension EntityBoost {
    var attributeBonusText: [String] {
        attributeBonuses.map { $0.description }
    }

    var derivedAttributeBoostsText: [String] {
        derivedAttributeBonuses.map { $0.description }
    }

    var strainIncreaseText: [String] { strain.descriptionLines }
}
