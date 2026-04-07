//  Created by Alex Skorulis on 8/4/2026.

import Foundation

struct PlayerCards: Codable, Sendable, Equatable {
    var job: Job?

    var jobCard: GameCard? { return job.map { .job($0) } }

    var allCards: [GameCard] {
        return [jobCard].compactMap(\.self)
    }

    /// Sum of `dailyHours` across active cards (tasks, employment, etc.).
    var totalDailyHours: Int {
        allCards.reduce(0) { $0 + $1.dailyHours }
    }
}
