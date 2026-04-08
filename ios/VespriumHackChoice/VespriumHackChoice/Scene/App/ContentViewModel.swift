import ASKCore
import Combine
import Knit
import KnitMacros
import Observation

@MainActor @Observable
final class ContentViewModel {

    var showMainMenu: Bool = false

    let mainStore: MainStore

    private var cancellables: Set<AnyCancellable> = []

    @Resolvable<Resolver>
    init(mainStore: MainStore) {
        self.mainStore = mainStore

        mainStore.$showMainMenu.sink { [unowned self] in
            self.showMainMenu = $0
        }
        .store(in: &cancellables)
    }
}
