import ASKCore
import Combine
import Knit
import KnitMacros
import Observation

@MainActor
@Observable
final class GameViewModel {
    let gameService: GameService

    var gameState: GameState
    var player: PlayerCharacter

    private var cancellables: Set<AnyCancellable> = []

    var isPlaying: Bool

    @Resolvable<Resolver>
    init(gameService: GameService, mainStore: MainStore) {
        self.gameService = gameService
        self.gameState = mainStore.gameState
        self.player = mainStore.player

        self.isPlaying = gameService.isPlaying

        gameService.$isPlaying.sink { [unowned self] in
            self.isPlaying = $0
        }
        .store(in: &cancellables)

        mainStore.$gameState.sink { [unowned self] in
            self.gameState = $0
        }
        .store(in: &cancellables)

        mainStore.$player.sink { [unowned self] in
            self.player = $0
        }
        .store(in: &cancellables)
    }

    func togglePlayback() {
        gameService.toggle()
    }
}
