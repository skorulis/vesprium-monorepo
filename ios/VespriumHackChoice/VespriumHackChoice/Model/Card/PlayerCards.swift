//  Created by Alex Skorulis on 8/4/2026.

import BioEnhancements
import BioStats
import Foundation

struct PlayerCards: Codable, Sendable, Equatable {
    var equippedJob: GameCard?
    var activities: [GameCard] = []
    var bodyEnhancements: [BioEnhancement] = []

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
        bodyEnhancements.map { GameCard.bodyEnhancement($0) }
    }

    var allCards: [GameCard] {
        let jobs = [jobCard].compactMap(\.self)
        return jobs + activityCards + bodyEnhancementCards
    }

    /// Sum of `dailyHours` across active cards (tasks, employment, etc.).
    var totalDailyHours: Int {
        allCards.reduce(0) { $0 + $1.dailyHours }
    }

    var totalStrain: Strain {
        allCards.reduce(Strain()) { $0 + $1.strain }
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
        bodyEnhancements: [BioEnhancement] = []
    ) {
        self.equippedJob = equippedJob
        self.activities = activities
        self.bodyEnhancements = bodyEnhancements
    }

    /// Convenience for previews and tests.
    init(job: Job?, activities: [GameCard] = [], bodyEnhancements: [BioEnhancement] = []) {
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
        case let .bodyEnhancement(mod):
            bodyEnhancements.append(mod)
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
        case let .bodyEnhancement(mod):
            bodyEnhancements = bodyEnhancements.filter { $0 != mod }
        case .monthlyChoice:
            break
        }
    }
}
