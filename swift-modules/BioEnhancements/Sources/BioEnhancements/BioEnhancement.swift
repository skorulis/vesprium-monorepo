//  Created by Alexander Skorulis on 7/4/2026.

import Foundation
import BioStats
import Util

public enum BioEnhancement: String, Codable, Sendable, Equatable, CaseIterable {
    case chlorophyllSkin
    case barometricEars
    case muscleEnergyImplants
    case brainOverclock
    case subdermalArmor
    case thickendedSkin
    case faceSculpting
    case socialPheromoneGlands
    case oxygenatedBlood
    case raptorClaws
    case retractableClaws
    

    public var name: String {
        rawValue.fromCaseName
    }

    public var text: String {
        switch self {
        case .chlorophyllSkin:
            return "Absorbs energy from the sun to reduce food needs"
        case .barometricEars:
            return "Eardrums sensitive enough to detect changes in barometric pressure"
        case .muscleEnergyImplants:
            return "Implants that hold energy that give a boost to strength when needed"
        case .brainOverclock:
            return "Forces the neurons in the brain to transmit faster increasing overall thought processing"
        case .subdermalArmor:
            return "Metal plates embedded in the body's skin that reduces damage"
        case .thickendedSkin:
            return "Thicker skin that reduces damage"
        case .faceSculpting:
            return "Brings out the natural beauty of the face"
        case .socialPheromoneGlands:
            return "Controlled pheromone release improves social influence"
        case .oxygenatedBlood:
            return "Engineered blood proteins carry oxygen more efficiently"
        case .raptorClaws:
            return "Bone claws embedded into the fingers"
        case .retractableClaws:
            return "Metal claws that can be hidden back inside the hands when not in use"
        }
    }

    public var technicalDetails: String? {
        switch self {
        case .muscleEnergyImplants:
            return "Fairly simple biological implants which store excess energy while inactive and release it when the muscles are under high stress"
        case .brainOverclock:
            return "A crystal and bio battery implanted in the back of the head provides a constant pulse which forces neurons to work overtime"
        default:
            return nil
        }
    }

    public var baseCost: Int {
        switch self {
        case .chlorophyllSkin:
            return 100
        case .barometricEars:
            return 100
        case .muscleEnergyImplants:
            return 200
        case .brainOverclock:
            return 500
        case .subdermalArmor:
            return 200
        case .thickendedSkin:
            return 200
        case .faceSculpting:
            return 100
        case .socialPheromoneGlands:
            return 180
        case .oxygenatedBlood:
            return 260
        case .raptorClaws:
            return 150
        case .retractableClaws:
            return 200
        }
    }

    public var attributeBonuses: [AttributeBonus] {
        switch self {
        case .chlorophyllSkin:
            return [AttributeBonus(attribute: .stability, value: -1)]
        case .muscleEnergyImplants:
            return [AttributeBonus(attribute: .strength, value: 50, kind: .multiplicative)]
        case .brainOverclock:
            return [
                AttributeBonus(attribute: .cognition, value: 50, kind: .multiplicative),
                AttributeBonus(attribute: .agility, value: 25, kind: .multiplicative),
            ]
        case .thickendedSkin:
            return [
                AttributeBonus(attribute: .charisma, value: -10, kind: .multiplicative),
            ]
        case .faceSculpting:
            return [
                AttributeBonus(attribute: .charisma, value: 25, kind: .multiplicative),
            ]
        case .socialPheromoneGlands:
            return [
                AttributeBonus(attribute: .charisma, value: 30, kind: .multiplicative),
                AttributeBonus(attribute: .stability, value: -10, kind: .multiplicative),
            ]
        case .oxygenatedBlood:
            return [
                AttributeBonus(attribute: .strength, value: 20, kind: .multiplicative),
                AttributeBonus(attribute: .agility, value: 20, kind: .multiplicative),
            ]
        case .raptorClaws:
            return [
                AttributeBonus(attribute: .agility, value: -10, kind: .multiplicative),
            ]
        default:
            return []
        }
    }

    public var derivedAttributeBonuses: [DerivedAttributeBonus] {
        switch self {
        case .subdermalArmor:
            return [
                DerivedAttributeBonus(attribute: .damageAbsorbtion, value: 1, kind: .additive)
            ]
        case .thickendedSkin:
            return [
                DerivedAttributeBonus(attribute: .damageAbsorbtion, value: 1, kind: .additive)
            ]
        case .raptorClaws:
            return [
                DerivedAttributeBonus(attribute: .damage, value: 50, kind: .multiplicative)
            ]
        case .retractableClaws:
            return [
                DerivedAttributeBonus(attribute: .damage, value: 50, kind: .multiplicative)
            ]
        default:
            return []
        }
    }

    public var strain: Strain {
        switch self {
        case .chlorophyllSkin:
            return .init(physical: 1)
        case .barometricEars:
            return .init()
        case .muscleEnergyImplants:
            return .init(physical: 2)
        case .brainOverclock:
            return .init(physical: 0, mental: 1)
        case .subdermalArmor:
            return .init(physical: 1)
        case .thickendedSkin:
            return .init(physical: 1)
        case .oxygenatedBlood:
            return .init(physical: 2)
        case .raptorClaws:
            return .init(physical: 1)
        case .retractableClaws:
            return .init(physical: 2)
        case .faceSculpting, .socialPheromoneGlands:
            return .none
        }
    }
    
    public var method: EnhancementMethod {
        switch self {
        case .chlorophyllSkin:
            return .geneGraft
        case .barometricEars:
            return .mechanicalImplant
        case .muscleEnergyImplants:
            return .geneGraft
        case .brainOverclock:
            return .mechanicalImplant
        case .subdermalArmor:
            return .mechanicalImplant
        case .thickendedSkin:
            return .geneGraft
        case .faceSculpting:
            return .surgery
        case .socialPheromoneGlands:
            return .geneGraft
        case .oxygenatedBlood:
            return .geneGraft
        case .raptorClaws:
            return .geneGraft
        case .retractableClaws:
            return .mechanicalImplant
        }
    }
}
