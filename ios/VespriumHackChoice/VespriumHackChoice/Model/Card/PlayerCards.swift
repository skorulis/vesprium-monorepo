//  Created by Alex Skorulis on 8/4/2026.

import BioEnhancements
import BioStats
import Foundation

struct PlayerCards: Codable, Sendable, Equatable {
    var equippedJob: GameCard?
    var activities: [GameCard] = []
    var bodyEnhancements: [GameCard] = []

    var job: Job? {
        guard let equippedJob else { return nil }
        if case .job(let occupation) = equippedJob { return occupation }
        return nil
    }

    var jobCard: GameCard? { equippedJob }

    var activityCards: [GameCard] {
        activities
    }

    var bodyEnhancementCards: [GameCard] {
        bodyEnhancements
    }

    var allCards: [GameCard] {
        let jobs = [jobCard].compactMap(\.self)
        return jobs + activityCards + bodyEnhancementCards
    }

    /// Sum of `dailyHours` across active cards (tasks, employment, etc.).
    var totalDailyHours: Int {
        allCards.reduce(0) { $0 + $1.dailyHours }
    }

    func hasEnhancement(_ enhancement: BioEnhancement) -> Bool {
        bodyEnhancementCards.contains { card in
            if case .bodyEnhancement(let installed) = card {
                return installed == enhancement
            }
            return false
        }
    }

    init(
        equippedJob: GameCard? = nil,
        activities: [GameCard] = [],
        bodyEnhancements: [GameCard] = []
    ) {
        self.equippedJob = equippedJob
        self.activities = activities
        self.bodyEnhancements = bodyEnhancements
    }

    /// Convenience for previews and tests.
    init(job: Job?, activities: [GameCard] = [], bodyEnhancements: [GameCard] = []) {
        if let job {
            self.equippedJob = .job(job)
        } else {
            self.equippedJob = nil
        }
        self.activities = activities
        self.bodyEnhancements = bodyEnhancements
    }
    
    /// All `AttributeBonus` values contributed by currently equipped body enhancements.
    var equippedAttributeBonuses: [AttributeBonus] {
        bodyEnhancementCards.flatMap { card -> [AttributeBonus] in
            if case .bodyEnhancement(let enhancement) = card {
                return enhancement.attributeBonuses
            }
            return []
        }
    }

    mutating func add(card: GameCard) {
        switch card {
        case .job:
            equippedJob = card
        case .activity:
            activities.append(card)
        case .bodyEnhancement:
            bodyEnhancements.append(card)
        case .monthlyChoice:
            break
        }
    }

    mutating func remove(card: GameCard) {
        switch card {
        case .job:
            equippedJob = nil
        case .activity:
            activities = activities.filter { $0 != card }
        case .bodyEnhancement:
            bodyEnhancements = bodyEnhancements.filter { $0 != card }
        case .monthlyChoice:
            break
        }
    }
}
