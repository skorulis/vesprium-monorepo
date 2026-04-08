//  Created by Alex Skorulis on 8/4/2026.

import Foundation

struct PlayerCards: Codable, Sendable, Equatable {
    var job: Job?
    var activities: [Activity] = []

    var jobCard: GameCard? { return job.map { .job($0) } }

    var activityCards: [GameCard] {
        return activities.map { .activity($0) }
    }

    var allCards: [GameCard] {
        let jobs = [jobCard].compactMap(\.self)
        return jobs + activityCards
    }

    /// Sum of `dailyHours` across active cards (tasks, employment, etc.).
    var totalDailyHours: Int {
        allCards.reduce(0) { $0 + $1.dailyHours }
    }

    var monthlyBalanceChange: Int {
        allCards.map { $0.monthlyMoneyChange }.reduce(0, +)
    }

    mutating func add(card: GameCard) {
        switch card {
        case .job(let job):
            self.job = job
        case .activity(let activity):
            self.activities.append(activity)
        }
    }
}
