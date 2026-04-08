//  Created by Alex Skorulis on 8/4/2026.

import BioEnhancements
import BioStats
import Foundation

/// Pure game math for a single ``PlayerCharacter`` snapshot (money is ignored unless added later).
struct GameCalculator {

    let player: PlayerCharacter

    /// Monthly coins from a job: base ``Job/monthlyIncome`` plus each ``Job/incomeBonuses`` entry
    /// (`coefficient ×` current value for that ``Attribute``).
    ///
    /// Farming only: if the player has ``BioEnhancement/barometricEars``, the result is 50% higher
    /// (×1.5, rounded down).
    func monthlyJobEarnings(for job: Job) -> Int {
        let fromAttributes = job.incomeBonuses.reduce(0) { total, entry in
            total + entry.value * player.attributes[entry.key]
        }
        var total = job.monthlyIncome + fromAttributes
        if job == .farming, player.cards.hasEnhancement(.barometricEars) {
            total = (total * 3) / 2
        }
        return total
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
