import ASKCore
import Combine
import Knit
import KnitMacros
import Observation

@MainActor
@Observable
final class PlayerCardsViewModel {
    var player: PlayerCharacter

    private var cancellables: Set<AnyCancellable> = []

    var equippedCards: [GameCard] {
        player.cards.allCards
    }

    @Resolvable<Resolver>
    init(mainStore: MainStore) {
        self.player = mainStore.player

        mainStore.$player.sink { [unowned self] in
            self.player = $0
        }
        .store(in: &cancellables)
    }
}
