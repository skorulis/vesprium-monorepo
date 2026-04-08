import ASKCoordinator
import ASKCore
import Combine
import Knit
import KnitMacros
import Observation

@MainActor
@Observable
final class PlayerCardsViewModel: CoordinatorViewModel {
    weak var coordinator: ASKCoordinator.Coordinator?

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

// MARK: - Logic

extension PlayerCardsViewModel {
    func presentDetails(card: GameCard) {
        let viewModel = CardDetailsViewModel(card: card, player: model.player)
        coordinator?.present(MainPath.cardDetails(viewModel), style: .sheet)
    }
}
