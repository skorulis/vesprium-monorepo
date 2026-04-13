// Created by Alex Skorulis on 13/4/2026.

import Foundation
import BioStats

struct Enemy: Codable, Sendable, Equatable {
    let id: UUID
    let kind: EnemyKind
    var health: Int

    init(kind: EnemyKind) {
        self.id = UUID()
        self.kind = kind
        self.health = kind.maxHealth
    }
}

enum EnemyKind: String, Codable, Sendable, Equatable {
    case rat

    /// Base damage amount
    var damage: Int {
        switch self {
        case .rat:
            return 2
        }
    }

    var agility: Int {
        switch self {
        case .rat:
            return 12
        }
    }

    var maxHealth: Int {
        switch self {
        case .rat:
            return 10
        }
    }

    /// Money gained when defeated
    var money: Int {
        return 10
    }
}
