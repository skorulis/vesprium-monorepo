import ASKCore
import BioStats
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

    private static var defaultGameState: GameState {
        .init(currentGameDate: SetupConstants.gameStartTime)
    }

    private static var defaultPlayer: PlayerCharacter {
        .init(dateOfBirth: SetupConstants.defaultPlayerDOB)
    }

    /// Root UI: main menu vs in-game shell. Not persisted.
    @Published var showMainMenu: Bool = true

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
        gameState = (try? keyValueStore.codable(forKey: Self.gameStateKey))
            ?? Self.defaultGameState
        player = (try? keyValueStore.codable(forKey: Self.playerKey))
            ?? Self.defaultPlayer
    }

    var isPristine: Bool {
        gameState == Self.defaultGameState && player == Self.defaultPlayer
    }

    func resetToNewGame() {
        gameState = Self.defaultGameState
        player = Self.defaultPlayer
    }

    func exitToMenu() {
        showMainMenu = true
    }
}
