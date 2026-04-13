// Created by Alex Skorulis on 14/4/2026.

import ASKCoordinator
import Foundation
import Knit
import KnitMacros

@MainActor @Observable final class PlayerViewModel: CoordinatorViewModel {
    weak var coordinator: ASKCoordinator.Coordinator?

    private let mainStore: MainStore

    @Resolvable<Resolver>
    init(mainStore: MainStore) {
        self.mainStore = mainStore
    }

    var player: PlayerCharacter {
        mainStore.player
    }
}
