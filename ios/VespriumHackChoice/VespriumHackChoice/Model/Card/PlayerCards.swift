//  Created by Alex Skorulis on 8/4/2026.

import BioStats
import Foundation

struct PlayerCards: Codable, Sendable, Equatable {
    /// Current job, if any, with the in-game date it was added.
    var equippedJob: GameCardInstance?
    var activities: [GameCardInstance] = []
    var bodyEnhancements: [GameCardInstance] = []

    var job: Job? {
        guard let equippedJob else { return nil }
        if case .job(let occupation) = equippedJob.card { return occupation }
        return nil
    }

    var jobCard: GameCard? { equippedJob?.card }

    var activityCards: [GameCard] {
        activities.map(\.card)
    }

    var bodyEnhancementCards: [GameCard] {
        bodyEnhancements.map(\.card)
    }

    var allCards: [GameCard] {
        let jobs = [jobCard].compactMap(\.self)
        return jobs + activityCards + bodyEnhancementCards
    }

    /// Sum of `dailyHours` across active cards (tasks, employment, etc.).
    var totalDailyHours: Int {
        allCards.reduce(0) { $0 + $1.dailyHours }
    }

    var monthlyBalanceChange: Int {
        allCards.map { $0.monthlyMoneyChange }.reduce(0, +)
    }

    init(
        equippedJob: GameCardInstance? = nil,
        activities: [GameCardInstance] = [],
        bodyEnhancements: [GameCardInstance] = []
    ) {
        self.equippedJob = equippedJob
        self.activities = activities
        self.bodyEnhancements = bodyEnhancements
    }

    /// Convenience for previews and tests: wrap a job with its add date.
    init(job: Job?, addedOn date: VespriumDate, activities: [GameCardInstance] = []) {
        if let job {
            self.equippedJob = GameCardInstance(date: date, card: .job(job))
        } else {
            self.equippedJob = nil
        }
        self.activities = activities
    }

    mutating func add(card: GameCard, on date: VespriumDate) {
        let instance = GameCardInstance(date: date, card: card)
        switch card {
        case .job:
            equippedJob = instance
        case .activity:
            activities.append(instance)
        case .bodyEnhancement:
            bodyEnhancements.append(instance)
        }
    }
}
