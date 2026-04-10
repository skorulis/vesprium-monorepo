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
                attributeValue: player.effectiveAttributes[entry.key]
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

    struct MonthlyLivingExpensesBreakdown: Sendable, Equatable {
        /// `20 + 1 × strength`
        var food: Int
        var housing: Int
        /// Sum of monthly costs for equipped activity cards (same magnitude as negative `monthlyMoneyChange` on cards).
        var activityCards: Int

        /// Food, housing, and activity card costs combined (for expense breakdown UI).
        var total: Int {
            food + housing + activityCards
        }
    }

    /// Fixed monthly costs: food scales with strength; housing is flat; activity row sums equipped activities’ costs.
    func monthlyLivingExpensesBreakdown() -> MonthlyLivingExpensesBreakdown {
        let strength = player.effectiveAttributes[.strength]
        let food = 20 + strength
        return MonthlyLivingExpensesBreakdown(
            food: food,
            housing: 30,
            activityCards: monthlyActivityCardsCost()
        )
    }

    /// Sum of monthly costs from equipped activity cards (`max(0, -monthlyMoneyChange)` each).
    private func monthlyActivityCardsCost() -> Int {
        player.cards.activityCards.reduce(0) { $0 + max(0, -$1.monthlyMoneyChange) }
    }

    /// Net monthly coins: job earnings (including attribute and enhancement bonuses) plus activity costs and other
    /// card effects, minus monthly living expenses (food and housing only—activities are already in the card sum).
    func monthlyBalanceChange() -> Int {
        let living = monthlyLivingExpensesBreakdown()
        let fromCards = player.cards.allCards.reduce(0) { total, card in
            switch card {
            case .job(let job):
                return total + monthlyJobEarnings(for: job)
            default:
                return total + card.monthlyMoneyChange
            }
        }
        return fromCards - living.food - living.housing
    }

    /// Weakness chance from aging, offset by vitality.
    ///
    /// - Base chance is linearly scaled from 0 at age 20 to 100 at age 100.
    /// - Ages below 20 use 0; ages above 100 use 100.
    /// - Vitality is subtracted from the base chance and the result is clamped to 0...100.
    func weaknessChance(on currentGameDate: VespriumDate) -> Int {
        let age = player.ageInFullYears(on: currentGameDate)
        let scaledAgeChance = ((age - 20) * 100) / 80
        let baseChance = min(100, max(0, scaledAgeChance))
        let adjustedChance = baseChance - player.effectiveAttributes[.vitality]
        return min(100, max(0, adjustedChance))
    }

    /// Daily strain from insufficient rest.
    ///
    /// If the player is busy for more than 16 hours/day, they are resting fewer than 8 hours and
    /// gain +1 physical and +1 mental strain.
    func calculateStrain() -> Strain {
        let base = calculateTimeStrain(busyHours: player.cards.totalDailyHours)
        return base
    }

    func calculateTimeStrain(busyHours: Int) -> Strain {
        let safeHours = VespriumCalendar.hoursPerDay - 8 // Get at least 8 hours rest
        let badHours = VespriumCalendar.hoursPerDay - 4 // Less than 4 hours rest is far worse
        var value = max(busyHours - safeHours, 0)
        if busyHours > badHours {
            value += (1...(busyHours - badHours)).reduce(0, +)
        }

        return Strain(physical: value, mental: value)
    }
}
