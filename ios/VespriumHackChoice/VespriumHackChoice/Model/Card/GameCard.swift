//  Created by Alex Skorulis on 8/4/2026.

import Foundation
import SwiftUI

enum GameCard: Codable, Sendable, Equatable {
    case job(Job)
    case activity(Activity)

    var name: String {
        switch self {
        case let .job(job): return job.name
        case let .activity(activity): return activity.name
        }
    }

    var icon: Image {
        switch self {
        default:
            return Image(systemName: "photo.artframe")
        }
    }

    var monthlyMoneyChange: Int {
        switch self {
        case let .job(job): return job.monthlyIncome
        case let .activity(activity): return -activity.monthlyCost
        }
    }

    var dailyHours: Int {
        switch self {
        case let .job(job): return job.dailyHours
        case let .activity(activity): return activity.dailyHours
        }
    }

    var type: GameCardType {
        switch self {
        case .job: return .job
        case .activity: return .activity
        }
    }
}

enum GameCardType {
    case job
    case activity
}
