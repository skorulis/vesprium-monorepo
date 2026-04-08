//  Created by Alex Skorulis on 8/4/2026.

import BioEnhancements
import BioStats
import Foundation
import Knit
import KnitMacros

struct CalculationsService {

    let mainStore: MainStore

    @Resolvable<Resolver>
    init(mainStore: MainStore) {
        self.mainStore = mainStore
    }

    /// Monthly coins from a job: base ``Job/monthlyIncome`` plus each ``Job/incomeBonuses`` entry
    /// (`coefficient ×` current value for that ``Attribute``).
    ///
    /// Farming only: if the player has ``BioEnhancement/barometricEars``, the result is 50% higher
    /// (×1.5, rounded down).
    @MainActor
    func monthlyJobEarnings(for job: Job) -> Int {
        Self.monthlyJobEarnings(
            for: job,
            attributes: mainStore.player.attributes,
            cards: mainStore.player.cards
        )
    }

    func monthlyJobEarnings(for job: Job, attributes: AttributeValues, cards: PlayerCards = PlayerCards()) -> Int {
        Self.monthlyJobEarnings(for: job, attributes: attributes, cards: cards)
    }

    /// Net monthly coins: job earnings (including attribute and enhancement bonuses) plus activity costs and other
    /// card effects.
    static func monthlyJobEarnings(
        for job: Job,
        attributes: AttributeValues,
        cards: PlayerCards = PlayerCards()
    ) -> Int {
        let fromAttributes = job.incomeBonuses.reduce(0) { total, entry in
            total + entry.value * attributes[entry.key]
        }
        var total = job.monthlyIncome + fromAttributes
        if job == .farming, cards.hasEnhancement(.barometricEars) {
            total = (total * 3) / 2
        }
        return total
    }

    /// Net monthly coins for the given loadout (job income includes bonuses from
    /// ``monthlyJobEarnings(for:attributes:cards:)``).
    static func monthlyBalanceChange(attributes: AttributeValues, cards: PlayerCards) -> Int {
        cards.allCards.reduce(0) { total, card in
            switch card {
            case .job(let job):
                return total + Self.monthlyJobEarnings(for: job, attributes: attributes, cards: cards)
            default:
                return total + card.monthlyMoneyChange
            }
        }
    }

    @MainActor
    func monthlyBalanceChange() -> Int {
        Self.monthlyBalanceChange(attributes: mainStore.player.attributes, cards: mainStore.player.cards)
    }
}
