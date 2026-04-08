//  Created by Alex Skorulis on 8/4/2026.

import BioEnhancements
import BioStats
import Foundation

/// Pure game math for a single ``PlayerCharacter`` snapshot (money is ignored unless added later).
struct GameCalculator {

    let player: PlayerCharacter

    struct JobIncomeContribution: Sendable, Equatable {
        let attribute: Attribute
        let coefficient: Int
        let attributeValue: Int

        var amount: Int {
            coefficient * attributeValue
        }
    }

    struct JobIncomeBreakdown: Sendable, Equatable {
        let baseIncome: Int
        let contributions: [JobIncomeContribution]
        let preSynergyTotal: Int
        let synergyBonus: Int?
        let total: Int
    }

    /// Detailed monthly income components for a job.
    func monthlyJobIncomeBreakdown(for job: Job) -> JobIncomeBreakdown {
        let contributions = job.incomeBonuses.map { entry in
            JobIncomeContribution(
                attribute: entry.key,
                coefficient: entry.value,
                attributeValue: player.attributes[entry.key]
            )
        }
        let fromAttributes = contributions.reduce(0) { $0 + $1.amount }
        let preSynergyTotal = job.monthlyIncome + fromAttributes

        if job == .farming, player.cards.hasEnhancement(.barometricEars) {
            let total = (preSynergyTotal * 3) / 2
            return JobIncomeBreakdown(
                baseIncome: job.monthlyIncome,
                contributions: contributions,
                preSynergyTotal: preSynergyTotal,
                synergyBonus: total - preSynergyTotal,
                total: total
            )
        }

        return JobIncomeBreakdown(
            baseIncome: job.monthlyIncome,
            contributions: contributions,
            preSynergyTotal: preSynergyTotal,
            synergyBonus: nil,
            total: preSynergyTotal
        )
    }

    /// Monthly coins from a job: base ``Job/monthlyIncome`` plus each ``Job/incomeBonuses`` entry
    /// (`coefficient ×` current value for that ``Attribute``).
    ///
    /// Farming only: if the player has ``BioEnhancement/barometricEars``, the result is 50% higher
    /// (×1.5, rounded down).
    func monthlyJobEarnings(for job: Job) -> Int {
        monthlyJobIncomeBreakdown(for: job).total
    }

    /// Net monthly coins: job earnings (including attribute and enhancement bonuses) plus activity costs and other
    /// card effects.
    func monthlyBalanceChange() -> Int {
        player.cards.allCards.reduce(0) { total, card in
            switch card {
            case .job(let job):
                return total + monthlyJobEarnings(for: job)
            default:
                return total + card.monthlyMoneyChange
            }
        }
    }
}
