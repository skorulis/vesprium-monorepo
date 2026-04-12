//  Created by Alex Skorulis on 7/4/2026.

import Foundation
import SwiftUI
import BioStats

struct GameEvent: Sendable, Codable, Equatable {
    let text: String
    let skippable: Bool
    let kind: GameEventKind

    init(
        text: String,
        kind: GameEventKind,
        skippable: Bool = true
    ) {
        self.text = text
        self.kind = kind
        self.skippable = skippable
    }
}

enum GameEventKind: Sendable, Codable, Equatable {
    case cards([GameCard])
    case attributeTrade(from: Attribute, to: Attribute, amount: Int)

    var icon: Image {
        switch self {
        case .cards:
            return Image(systemName: "exclamationmark.bubble.fill")
        case .attributeTrade:
            return Image(systemName: "arrow.left.arrow.right.circle.fill")
        }
    }
}
