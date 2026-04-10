//  Created by Alexander Skorulis on 11/4/2026.

import BioStats
import Foundation
import Util

struct StatusEffect: Codable, Sendable, Equatable {
    let kind: StatusEffectKind
    let endDate: VespriumDate
}

enum StatusEffectKind: String, Codable, Sendable, Equatable {
    case heatWave
    case coldSnap

    var strain: Strain {
        switch self {
        case .heatWave, .coldSnap:
            // TODO: Only for jobs outdoors
            return .init(physical: 2)
        }
    }
}

struct StatusEffectImpact {
    let strain: Strain

    static var none: Self {
        return .init(strain: Strain())
    }
}
