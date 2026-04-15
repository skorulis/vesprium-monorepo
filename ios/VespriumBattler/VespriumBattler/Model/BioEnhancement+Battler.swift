// Created by Alex Skorulis on 15/4/2026.

import BioEnhancements
import Foundation

extension BioEnhancement {

    // Enhancements that are useless in the context of this game
    var isUseless: Bool {
        switch self {
        case .chlorophyllSkin, .barometricEars:
            return true
        default:
            return false
        }
    }

    var grantedAbility: Ability? {
        switch self {
        case .pscycicUnblock:
            return .psychicBlast
        default:
            return nil
        }
    }
}
