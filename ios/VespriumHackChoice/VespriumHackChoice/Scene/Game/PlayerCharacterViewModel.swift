import ASKCore
import Combine
import Knit
import KnitMacros
import Observation

@MainActor
@Observable
final class PlayerCharacterViewModel {
    var model: PlayerCharacterView.Model

    private var cancellables: Set<AnyCancellable> = []

    @Resolvable<Resolver>
    init(mainStore: MainStore) {
        self.model = .init(gameState: mainStore.gameState, player: mainStore.player)

        mainStore.$gameState.sink { [unowned self] in
            self.model.gameState = $0
        }
        .store(in: &cancellables)

        mainStore.$player.sink { [unowned self] in
            self.model.player = $0
        }
        .store(in: &cancellables)
    }
}
