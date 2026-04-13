// Created by Alex Skorulis on 13/4/2026.

import Foundation
import BioStats

struct Enemy: Codable, Sendable, Equatable {
    let id: UUID
    let kind: EnemyKind

    var storedTime: TimeInterval = 0
    var health: Int

    init(kind: EnemyKind) {
        self.id = UUID()
        self.kind = kind
        self.health = kind.details.maxHealth
    }
    
    var details: EnemyDetails { kind.details }
}

struct EnemyDetails: Codable, Sendable, Equatable {
    /// Base damage amount
    let damage: Int
    let agility: Int
    let attackRate: TimeInterval
    let maxHealth: Int
    /// Money gained when defeated
    let money: Int
}

enum EnemyKind: String, Codable, Sendable, Equatable {
    case rat

    var details: EnemyDetails {
        switch self {
        case .rat:
            return EnemyDetails(
                damage: 1,
                agility: 12,
                attackRate: 2.5,
                maxHealth: 10,
                money: 10
            )
        }
    }
}
