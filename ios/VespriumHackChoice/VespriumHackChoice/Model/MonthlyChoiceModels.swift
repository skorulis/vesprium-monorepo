//  Created by Alex Skorulis on 9/4/2026.

import BioStats
import Foundation

/// Effect applied when the player picks a monthly choice card (never equipped).
enum MonthlyChoiceEffect: Codable, Sendable, Equatable {
    case moneyDelta(Int)
    case vitalityDelta(Int)
    case attributeDelta(attribute: Attribute, amount: Int)
    /// Pay coins, then grant attribute (one choice: course / training).
    case payTuition(cost: Int, attribute: Attribute, amount: Int)
    /// Success: add money. Failure: lose vitality (year totals updated like weakness).
    case riskMoneyOrVitality(moneyIfSuccess: Int, vitalityLossIfFail: Int, successPercent: Int)
}

/// One selectable option in a monthly dilemma (shown as a ``GameCard``).
struct MonthlyChoiceOption: Codable, Sendable, Equatable {
    var id: String
    var title: String
    /// Short hint under the title (replaces hours / money in the card footer).
    var hint: String
    var effect: MonthlyChoiceEffect
}
