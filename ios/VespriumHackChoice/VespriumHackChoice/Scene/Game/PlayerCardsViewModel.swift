import ASKCore
import Combine
import Knit
import KnitMacros
import Observation

@MainActor
@Observable
final class PlayerCardsViewModel {

    var model: PlayerCardsView.Model

    private var cancellables: Set<AnyCancellable> = []

    @Resolvable<Resolver>
    init(mainStore: MainStore) {
        self.model = .init(player: mainStore.player)

        mainStore.$player.sink { [unowned self] in
            self.model.player = $0
        }
        .store(in: &cancellables)
    }
}
