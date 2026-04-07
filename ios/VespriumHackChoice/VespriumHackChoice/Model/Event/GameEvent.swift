//  Created by Alex Skorulis on 7/4/2026.

import Foundation

struct GameEvent: Sendable, Codable, Equatable {
    let text: String
    let cards: [GameCard]
    let skippable: Bool

    init(
        text: String,
        cards: [GameCard],
        skippable: Bool = true
    ) {
        self.text = text
        self.cards = cards
        self.skippable = skippable
    }
}
