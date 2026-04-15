// Created by Alexander Skorulis on 13/4/2026.

import BioStats
import Foundation
import SwiftUI

enum MentalAbility: String, Codable, Sendable, Equatable, CaseIterable {

    case hardPush // TODO: Rename
    case focusSpike
    case precisionStrike

    var text: String {
        switch self {
        case .hardPush:
            return "Boost damage by 50% for 2s"
        case .focusSpike:
            return "Slows player perception of time for 5s"
        case .precisionStrike:
            return "Doubles chance to hit for 5s"
        }
    }

    var duration: TimeInterval {
        switch self {
        case .hardPush:
            return 2
        case .focusSpike:
            return 5
        case .precisionStrike:
            return 5
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
        }
    }

    var derivedAttributeBonuses: [DerivedAttributeBonus] {
        switch self {
        case .hardPush:
            return [
                DerivedAttributeBonus(attribute: .damage, value: 50, kind: .multiplicative),
            ]
        default:
            return []
        }
    }
}
