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
        case let .activity(activity): return activity.details.name
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
        case let .activity(activity): return -activity.details.monthlyCost
        case .bodyEnhancement: return 0
        }
    }

    var dailyHours: Int {
        switch self {
        case let .job(job): return job.dailyHours
        case let .activity(activity): return activity.details.dailyHours
        case .bodyEnhancement: return 0
        }
    }

    var type: GameCardType {
        switch self {
        case .job: return .job
        case .activity: return .activity
        case .bodyEnhancement: return .bodyEnhancement
        }
    }
    
    var price: Int {
        switch self {
        case .job, .activity:
            return 0
        case .bodyEnhancement(let mod):
            return mod.baseCost
        }
    }
}

enum GameCardType {
    case job
    case activity
    case bodyEnhancement
}
