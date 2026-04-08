import ASKCore
import Combine
import Knit
import KnitMacros
import Observation

@MainActor
@Observable
final class GameViewModel {
    let gameService: GameService
    private let mainStore: MainStore

    var gameState: GameState
    var player: PlayerCharacter

    private var cancellables: Set<AnyCancellable> = []

    @Resolvable<Resolver>
    init(gameService: GameService, mainStore: MainStore) {
        self.gameService = gameService
        self.mainStore = mainStore
        self.gameState = mainStore.gameState
        self.player = mainStore.player

        mainStore.$gameState.sink { [unowned self] in
            self.gameState = $0
        }
        .store(in: &cancellables)

        mainStore.$player.sink { [unowned self] in
            self.player = $0
        }
        .store(in: &cancellables)
    }

    func advanceTime() {
        gameService.advanceTime()
    }

    func resolvePendingEvent(selecting card: GameCard?) {
        gameService.resolvePendingEvent(selecting: card)
    }

    func resolveYearReview() {
        gameService.resolveYearReview()
    }

    func exitToMenu() {
        mainStore.exitToMenu()
    }
}
