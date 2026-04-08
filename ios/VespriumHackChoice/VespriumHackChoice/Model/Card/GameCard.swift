//  Created by Alex Skorulis on 8/4/2026.

import BioEnhancements
import Foundation
import SwiftUI

enum GameCard: Codable, Sendable, Equatable {
    case job(Job)
    case activity(Activity)
    case bodyEnhancement(BioEnhancement)

    var name: String {
        switch self {
        case let .job(job): return job.name
        case let .activity(activity): return activity.name
        case let .bodyEnhancement(mod): return mod.name
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
        case let .bodyEnhancement(mod): return 0
        }
    }

    var dailyHours: Int {
        switch self {
        case let .job(job): return job.dailyHours
        case let .activity(activity): return activity.dailyHours
        case let .bodyEnhancement(mod): return 0
        }
    }

    var type: GameCardType {
        switch self {
        case .job: return .job
        case .activity: return .activity
        case .bodyEnhancement: return .bodyEnhancement
        }
    }
}

enum GameCardType {
    case job
    case activity
    case bodyEnhancement
}
