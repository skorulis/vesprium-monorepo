import Combine
import Knit
import KnitMacros
import Observation

@MainActor
@Observable
final class MainMenuViewModel {

    private let mainStore: MainStore

    private(set) var isPristine: Bool

    private var cancellables: Set<AnyCancellable> = []

    @Resolvable<Resolver>
    init(mainStore: MainStore) {
        self.mainStore = mainStore
        self.isPristine = mainStore.isPristine

        Publishers.CombineLatest(mainStore.$gameState, mainStore.$player)
            .sink { [unowned self] _, _ in
                self.isPristine = self.mainStore.isPristine
            }
            .store(in: &cancellables)
    }

    func continueGame() {
        mainStore.showMainMenu = false
    }

    func startNewGame() {
        mainStore.resetToNewGame()
        mainStore.showMainMenu = false
    }
}
