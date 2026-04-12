// Created by Alex Skorulis on 13/4/2026.

import Foundation
import BioStats

struct Enemy: Codable, Sendable, Equatable {
    let level: Int
    
}

enum EnemyKind {
    case rat
}
