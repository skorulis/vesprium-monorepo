// Created by Alexander Skorulis on 13/4/2026.

import BioStats
import Foundation
import SwiftUI

enum MentalAbility: String, Codable, Sendable, Equatable, CaseIterable {

    case hardPush // TODO: Rename
    case focusSpike
    case precisionStrike
    case psychicBlast

    var text: String {
        switch self {
        case .hardPush:
            return "Boost damage by 50% for 2s"
        case .focusSpike:
            return "Slows player perception of time for 5s"
        case .precisionStrike:
            return "50% higher chance to hit"
        case .psychicBlast:
            return "Emits mental energy to stun enemies"
        }
    }

    var duration: TimeInterval {
        switch self {
        case .hardPush:
            return 2
        case .focusSpike:
            return 5
        case .precisionStrike:
            return 2
        case .psychicBlast:
            return 0
        }
    }

    var strain: Strain {
        switch self {
        case .hardPush:
            return Strain(physical: 5)
        case .focusSpike:
            return Strain(mental: 7)
        case .precisionStrike:
            return Strain(mental: 5)
        case .psychicBlast:
            return Strain(mental: 8)
        }
    }

    var icon: Image {
        switch self {
        case .hardPush:
            return Image(systemName: "arrow.2.circlepath.circle")
        case .focusSpike:
            return Image(systemName: "sparkle")
        case .precisionStrike:
            return Image(systemName: "dot.scope")
        case .psychicBlast:
            return Image(systemName: "brain")
        }
    }

    var derivedAttributeBonuses: [DerivedAttributeBonus] {
        switch self {
        case .hardPush:
            return [
                DerivedAttributeBonus(attribute: .damage, value: 50, kind: .multiplicative),
            ]
        case .precisionStrike:
            return [
                DerivedAttributeBonus(attribute: .hitChance, value: 50, kind: .multiplicative),
            ]
        default:
            return []
        }
    }
}
