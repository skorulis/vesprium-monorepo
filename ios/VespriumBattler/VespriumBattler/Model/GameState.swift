// Created by Alex Skorulis on 13/4/2026.

import Foundation

struct GameState: Codable, Sendable, Equatable {

    var phase: GameStatePhase = .menu

}

enum GameStatePhase: String, Codable, Sendable, Equatable {

    case menu
    case battle
    case shop
}
