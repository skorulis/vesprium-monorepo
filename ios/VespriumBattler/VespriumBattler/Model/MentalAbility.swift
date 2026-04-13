// Created by Alexander Skorulis on 13/4/2026.

import Foundation
import SwiftUI

enum MentalAbility: String, Codable, Sendable, Equatable, CaseIterable {

    case focusSpike

    var text: String {
        switch self {
        case .focusSpike:
            return "Slows time for 5s"
        }
    }

    var cooldown: TimeInterval {
        switch self {
        case .focusSpike:
            return 10
        }
    }

    var duration: TimeInterval {
        switch self {
        case .focusSpike:
            return 5
        }
    }

    var mentalLoad: Int {
        switch self {
        case .focusSpike:
            return 7
        }
    }

    var icon: Image {
        switch self {
        case .focusSpike:
            return Image(systemName: "sparkle")
        }
    }
}
