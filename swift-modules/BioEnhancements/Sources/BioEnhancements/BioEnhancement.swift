//  Created by Alexander Skorulis on 7/4/2026.

import Foundation
import BioStats

public enum BioEnhancement: String, Codable, Sendable, Equatable, CaseIterable {
    case chlorophyllSkin
    case barometricEars
    case muscleEnergyImplants

    public var name: String {
        rawValue.capitalized
    }

    public var text: String {
        switch self {
        case .chlorophyllSkin:
            return "Absorbs energy from the sun to reduce food needs"
        case .barometricEars:
            return "Eardrums sensitive enough to detect changes in barometric pressure"
        case .muscleEnergyImplants:
            return "Implants that hold energy that give a boost to strength when needed "
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
        }
    }

    public var attributeBonuses: [AttributeBonus] {
        switch self {
        case .chlorophyllSkin:
            return [AttributeBonus(attribute: .stability, value: -1)]
        case .muscleEnergyImplants:
            return [AttributeBonus(attribute: .strength, value: 50, kind: .multiplicative)]
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
        }
    }
}
