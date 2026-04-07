import ASKCore
import Combine
import Knit
import KnitMacros
import Observation

@MainActor
@Observable
final class PlayerCharacterWrapperViewModel {
    var gameState: GameState
    var player: PlayerCharacter

    private var cancellables: Set<AnyCancellable> = []

    @Resolvable<Resolver>
    init(mainStore: MainStore) {
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
}
