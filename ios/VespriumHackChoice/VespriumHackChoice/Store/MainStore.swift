import ASKCore
import Foundation
import Knit
import KnitMacros
import Observation

/// App data store: active session persisted via `PKeyValueStore`.
@MainActor
final class MainStore: ObservableObject {
    private let keyValueStore: PKeyValueStore

    private static let gameStateKey = "game.v1"
    private static let playerKey = "player.v1"

    @Published var gameState: GameState {
        didSet {
            try? keyValueStore.set(codable: gameState, forKey: Self.gameStateKey)
        }
    }

    @Published var player: PlayerCharacter {
        didSet {
            try? keyValueStore.set(codable: player, forKey: Self.playerKey)
        }
    }

    @Resolvable<Resolver>
    init(keyValueStore: PKeyValueStore) {
        self.keyValueStore = keyValueStore
        gameState = (try? keyValueStore.codable(forKey: Self.gameStateKey)) ?? .init(currentGameDate: Date())
        player = (try? keyValueStore.codable(forKey: Self.playerKey)) ?? .init(dateOfBirth: Date())
    }
}
