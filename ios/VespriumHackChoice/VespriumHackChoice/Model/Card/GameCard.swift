//  Created by Alex Skorulis on 8/4/2026.

import Foundation
import SwiftUI

enum GameCard: Codable, Sendable, Equatable {
    case job(Job)

    var name: String {
        switch self {
        case let .job(job): return job.name
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
        }
    }

    var dailyHours: Int {
        switch self {
        case let .job(job): return job.dailyHours
        }
    }
}
