//  Created by Alexander Skorulis on 7/4/2026.

import Foundation
import BioStats

public enum BioEnhancement: String, Codable, Sendable, Equatable, CaseIterable {
    case chlorophyllSkin
    case barometricEars
    
    public var name: String {
        rawValue.capitalized
    }
    
    var text: String {
        switch self {
        case .chlorophyllSkin:
            return "Absorbs energy from the sun to reduce food needs"
        case .barometricEars:
            return "Eardrums sensitive enough to detect changes in barometric pressure"
        }
    }
    
    var baseCost: Int {
        switch self {
        case .chlorophyllSkin:
            return 100
        case .barometricEars:
            return 100
        }
    }
    
    var attributeBonuses: [AttributeBonus] {
        switch self {
        case .chlorophyllSkin:
            return [AttributeBonus(attribute: .stability, value: -1)]
        default:
            return []
        }
    }
}
