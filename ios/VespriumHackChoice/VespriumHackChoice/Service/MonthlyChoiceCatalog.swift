//  Created by Alex Skorulis on 9/4/2026.

import BioStats
import Foundation

/// Situation keys used to pick a monthly dilemma row.
enum MonthlyChoiceSituation: Sendable, Equatable {
    case any
    case moneyBelow(Int)
    case moneyAtLeast(Int)
    case vitalityAtMost(Int)
    case activityCountAtLeast(Int)
}

/// A catalog row: headline text plus two options (A/B).
struct MonthlyChoiceCatalogEntry: Sendable {
    var id: String
    var headline: String
    var optionA: MonthlyChoiceOption
    var optionB: MonthlyChoiceOption
    var situation: MonthlyChoiceSituation

    func matches(player: PlayerCharacter) -> Bool {
        switch situation {
        case .any:
            return true
        case .moneyBelow(let threshold):
            return player.money < threshold
        case .moneyAtLeast(let threshold):
            return player.money >= threshold
        case .vitalityAtMost(let threshold):
            return player.attributes[.vitality] <= threshold
        case .activityCountAtLeast(let count):
            return player.cards.activities.count >= count
        }
    }
}

/// Content table for monthly choice events: effect types, risk levels, and situation keys.
enum MonthlyChoiceCatalog {

    static let entries: [MonthlyChoiceCatalogEntry] = [
        MonthlyChoiceCatalogEntry(
            id: "overtime_vs_rest",
            headline: "Work piles up. Do you push through or protect your health?",
            optionA: MonthlyChoiceOption(
                id: "overtime_vs_rest_a",
                title: "Overtime push",
                hint: "+60 coins",
                effect: .moneyDelta(60)
            ),
            optionB: MonthlyChoiceOption(
                id: "overtime_vs_rest_b",
                title: "Rest and recover",
                hint: "+1 vitality",
                effect: .vitalityDelta(1)
            ),
            situation: .any
        ),
        MonthlyChoiceCatalogEntry(
            id: "side_gig_risk",
            headline: "A friend offers a one-off side gig. It could pay well—or go wrong.",
            optionA: MonthlyChoiceOption(
                id: "side_gig_risk_a",
                title: "Take the gig",
                hint: "70%: +120 · else −1 vitality",
                effect: .riskMoneyOrVitality(moneyIfSuccess: 120, vitalityLossIfFail: 1, successPercent: 70)
            ),
            optionB: MonthlyChoiceOption(
                id: "side_gig_risk_b",
                title: "Decline",
                hint: "+25 coins (safe)",
                effect: .moneyDelta(25)
            ),
            situation: .any
        ),
        MonthlyChoiceCatalogEntry(
            id: "tight_budget",
            headline: "Funds are thin. You could hustle—or take a breather to recover.",
            optionA: MonthlyChoiceOption(
                id: "tight_budget_a",
                title: "Odd jobs",
                hint: "+90 coins",
                effect: .moneyDelta(90)
            ),
            optionB: MonthlyChoiceOption(
                id: "tight_budget_b",
                title: "Rest and hope",
                hint: "+1 vitality",
                effect: .vitalityDelta(1)
            ),
            situation: .moneyBelow(400)
        ),
        MonthlyChoiceCatalogEntry(
            id: "course_intelligence",
            headline: "A short course could sharpen your mind—if you pay tuition.",
            optionA: MonthlyChoiceOption(
                id: "course_intelligence_a",
                title: "Enroll",
                hint: "−200 coins · +1 intelligence",
                effect: .payTuition(cost: 200, attribute: .intelligence, amount: 1)
            ),
            optionB: MonthlyChoiceOption(
                id: "course_intelligence_b",
                title: "Skip for now",
                hint: "Keep your savings",
                effect: .moneyDelta(0)
            ),
            situation: .moneyAtLeast(1200)
        ),
        MonthlyChoiceCatalogEntry(
            id: "burnout",
            headline: "You feel run down. Push harder or ease off?",
            optionA: MonthlyChoiceOption(
                id: "burnout_a",
                title: "Grind harder",
                hint: "+40 coins",
                effect: .moneyDelta(40)
            ),
            optionB: MonthlyChoiceOption(
                id: "burnout_b",
                title: "Ease off",
                hint: "+1 vitality",
                effect: .vitalityDelta(1)
            ),
            situation: .vitalityAtMost(5)
        ),
        MonthlyChoiceCatalogEntry(
            id: "social_commitment",
            headline: "Two commitments compete for your evenings. Pick one focus.",
            optionA: MonthlyChoiceOption(
                id: "social_commitment_a",
                title: "Networking",
                hint: "+1 charisma",
                effect: .attributeDelta(attribute: .charisma, amount: 1)
            ),
            optionB: MonthlyChoiceOption(
                id: "social_commitment_b",
                title: "Quiet home time",
                hint: "+1 vitality",
                effect: .vitalityDelta(1)
            ),
            situation: .activityCountAtLeast(2)
        )
    ]
}
