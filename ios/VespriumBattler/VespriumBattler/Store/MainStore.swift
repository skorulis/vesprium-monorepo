// Created by Alex Skorulis on 13/4/2026.

import ASKCore
import Combine
import Knit
import KnitMacros
import Foundation

final class MainStore: ObservableObject {

    private let keyValueStore: PKeyValueStore
    private static let gameStateKey = "game.v1"
    private static let playerKey = "player.v1"

    @Published var player: PlayerCharacter

    @Resolvable<Resolver>
    init(keyValueStore: PKeyValueStore) {
        self.keyValueStore = keyValueStore

        player = (try? keyValueStore.codable(forKey: Self.playerKey)) ?? .init()
    }

}
