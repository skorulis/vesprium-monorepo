//  Created by Alex Skorulis on 8/4/2026.

import BioEnhancements
import Foundation
import SwiftUI

enum GameCard: Codable, Sendable, Equatable {
    case job(Job)
    case activity(Activity)
    case bodyEnhancement(BioEnhancement)
    /// Ephemeral offer option (monthly dilemma); never added to ``PlayerCards``.
    case monthlyChoice(MonthlyChoiceOption)

    var name: String {
        switch self {
        case let .job(job): return job.name
        case let .activity(activity): return activity.details.name
        case let .bodyEnhancement(mod): return mod.name
        case let .monthlyChoice(option): return option.title
        }
    }

    var icon: Image {
        switch self {
        case .monthlyChoice:
            return Image(systemName: "circle.lefthalf.filled.righthalf.striped.horizontal")
        default:
            return Image(systemName: "photo.artframe")
        }
    }

    var monthlyMoneyChange: Int {
        switch self {
        case let .job(job): return job.monthlyIncome
        case let .activity(activity): return -activity.details.monthlyCost
        case .bodyEnhancement: return 0
        case .monthlyChoice: return 0
        }
    }

    var dailyHours: Int {
        switch self {
        case let .job(job): return job.dailyHours
        case let .activity(activity): return activity.details.dailyHours
        case .bodyEnhancement: return 0
        case .monthlyChoice: return 0
        }
    }

    var type: GameCardType {
        switch self {
        case .job: return .job
        case .activity: return .activity
        case .bodyEnhancement: return .bodyEnhancement
        case .monthlyChoice: return .monthlyChoice
        }
    }

    var price: Int {
        switch self {
        case .job, .activity, .monthlyChoice:
            return 0
        case .bodyEnhancement(let mod):
            return mod.baseCost
        }
    }

    /// Whether the event overlay should show the purchase price above the card (body mods only).
    var showsPurchasePriceInOffer: Bool {
        switch self {
        case .bodyEnhancement(let mod):
            return mod.baseCost > 0
        case .job, .activity, .monthlyChoice:
            return false
        }
    }
}

enum GameCardType {
    case job
    case activity
    case bodyEnhancement
    case monthlyChoice
}
