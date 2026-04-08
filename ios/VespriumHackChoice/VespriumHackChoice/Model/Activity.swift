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
    case running
    case reading
    case yoga
    case volunteering
    case swimming
    case languages

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
                yearlyAttributeBonuses: [.intelligence: 2]
            )
        case .meditation:
            ActivityDetails(
                activity: self,
                monthlyCost: 5,
                dailyHours: 1,
                yearlyAttributeBonuses: [:]
            )
        case .running:
            ActivityDetails(
                activity: self,
                monthlyCost: 15,
                dailyHours: 1,
                yearlyAttributeBonuses: [.agility: 1]
            )
        case .reading:
            ActivityDetails(
                activity: self,
                monthlyCost: 10,
                dailyHours: 2,
                yearlyAttributeBonuses: [.intelligence: 1]
            )
        case .yoga:
            ActivityDetails(
                activity: self,
                monthlyCost: 40,
                dailyHours: 2,
                yearlyAttributeBonuses: [.stability: 1, .agility: 1]
            )
        case .volunteering:
            ActivityDetails(
                activity: self,
                monthlyCost: 0,
                dailyHours: 2,
                yearlyAttributeBonuses: [.charisma: 1]
            )
        case .swimming:
            ActivityDetails(
                activity: self,
                monthlyCost: 35,
                dailyHours: 1,
                yearlyAttributeBonuses: [.vitality: 1, .agility: 1]
            )
        case .languages:
            ActivityDetails(
                activity: self,
                monthlyCost: 50,
                dailyHours: 3,
                yearlyAttributeBonuses: [.intelligence: 1, .charisma: 1]
            )
        }
    }
}
