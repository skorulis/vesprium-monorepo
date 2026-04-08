//  Created by Alex Skorulis on 8/4/2026.

import BioStats
import Foundation

struct ActivityDetails: Sendable, Equatable {
    let activity: Activity
    var monthlyCost: Int
    var dailyHours: Int
    var yearlyAttributeBonuses: [Attribute: Int]

    var name: String { activity.rawValue.capitalized }
}

// Things that can be done outside of work
enum Activity: String, Codable, Sendable, Equatable, CaseIterable {
    case gym
    case school
    case meditation

    var details: ActivityDetails {
        switch self {
        case .gym:
            ActivityDetails(
                activity: self,
                monthlyCost: 20,
                dailyHours: 2,
                yearlyAttributeBonuses: [.strength: 1]
            )
        case .school:
            ActivityDetails(
                activity: self,
                monthlyCost: 50,
                dailyHours: 3,
                yearlyAttributeBonuses: [.intelligence: 1]
            )
        case .meditation:
            ActivityDetails(
                activity: self,
                monthlyCost: 5,
                dailyHours: 1,
                yearlyAttributeBonuses: [:]
            )
        }
    }
}
