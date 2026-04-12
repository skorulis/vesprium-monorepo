//  Created by Alex Skorulis on 7/4/2026.

import Foundation
import SwiftUI

struct GameEvent: Sendable, Codable, Equatable {
    let text: String
    let cards: [GameCard]
    let skippable: Bool
    let kind: GameEventKind

    init(
        text: String,
        cards: [GameCard],
        kind: GameEventKind,
        skippable: Bool = true
    ) {
        self.text = text
        self.cards = cards
        self.kind = kind
        self.skippable = skippable
    }
}

enum GameEventKind: Sendable, Codable, Equatable {
    case activity
    case trade
    case cards([GameCard])
    
    var icon: Image {
        switch self {
        case .activity:
            return Image(systemName: "paperplane.fill")
        case .trade:
            return Image(systemName: "arrow.left.arrow.right")
        case .cards:
            return Image(systemName: "exclamationmark.bubble.fill")
        }
    }
}
