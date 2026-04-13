// Created by Alex Skorulis on 13/4/2026.

import ASKCoordinator
import Foundation
import Knit
import KnitMacros

@Observable @MainActor final class MainMenuViewModel: CoordinatorViewModel {
    weak var coordinator: ASKCoordinator.Coordinator?

    private let mainStore: MainStore

    @Resolvable<Resolver>
    init(mainStore: MainStore) {
        self.mainStore = mainStore
    }

    func startBattle() {
        mainStore.gameState.phase = .battle
        coordinator?.push(MainPath.game)
    }
}
