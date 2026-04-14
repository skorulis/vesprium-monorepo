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

    /// The first level this enemy will appear at
    let startLevel: Int

    var rarity: Double = 1
}

enum EnemyKind: String, Codable, Sendable, Equatable, CaseIterable {
    case rat
    case hobo
    case spider

    var details: EnemyDetails {
        switch self {
        case .rat:
            return EnemyDetails(
                damage: 1,
                agility: 12,
                attackRate: 2.5,
                maxHealth: 10,
                money: 10,
                startLevel: 1,
            )
        case .hobo:
            return EnemyDetails(
                damage: 2,
                agility: 8,
                attackRate: 3,
                maxHealth: 25,
                money: 15,
                startLevel: 1,
            )
        case .spider:
            // TODO: Spiders should have a poison ability
            return EnemyDetails(
                damage: 3,
                agility: 10,
                attackRate: 3,
                maxHealth: 15,
                money: 25,
                startLevel: 2,
            )
        }
    }
}
