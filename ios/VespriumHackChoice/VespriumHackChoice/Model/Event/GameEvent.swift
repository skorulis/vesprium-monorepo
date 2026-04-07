//  Created by Alex Skorulis on 7/4/2026.

import Foundation

struct GameEvent: Sendable, Codable {
    let text: String
    let cards: [GameCard]
}
