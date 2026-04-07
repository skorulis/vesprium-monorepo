//  Created by Alexander Skorulis on 7/4/2026.

import Foundation
import BioStats

public enum BioEnhancement {
    case chlorophyllSkin
    
    var text: String {
        switch self {
        case .chlorophyllSkin:
            return "Absorbs energy from the sun to reduce food needs"
        }
    }
    
    var baseCost: Int {
        switch self {
        case .chlorophyllSkin:
            return 100
        }
    }
    
    var bonuses: [AttributeBonus] {
        switch self {
        case .chlorophyllSkin:
            return [AttributeBonus(attribute: .stability, value: -1)]
        }
    }
}
