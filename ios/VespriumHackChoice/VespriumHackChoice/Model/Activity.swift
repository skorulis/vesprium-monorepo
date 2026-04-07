//  Created by Alex Skorulis on 8/4/2026.

import Foundation

// Things that can be done outside of work
enum Activity: Codable, Sendable, Equatable {
    case gym
    case school
    case meditation

    var name: String {
        String(describing: self).capitalized
    }

    var monthlyCost: Int {
        switch self {
        case .gym: return 20
        case .school: return 50
        case .meditation: return 5
        }
    }

    var dailyHours: Int {
        switch self {
        case .gym: return 2
        case .school: return 3
        case .meditation: return 1
        }
    }
}
