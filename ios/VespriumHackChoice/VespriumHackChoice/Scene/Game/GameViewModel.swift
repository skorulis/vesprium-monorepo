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

    private var cancellables: Set<AnyCancellable> = []

    @Resolvable<Resolver>
    init(gameService: GameService, mainStore: MainStore) {
        self.gameService = gameService
        self.gameState = mainStore.gameState

        mainStore.$gameState.sink { [unowned self] in
            self.gameState = $0
        }
        .store(in: &cancellables)
    }

    func togglePlayback() {
        gameService.toggle()
    }
}
