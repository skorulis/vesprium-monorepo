// Created by Alex Skorulis on 13/4/2026.

import ASKCoordinator
import Combine
import Knit
import KnitMacros
import Foundation

@MainActor @Observable final class GameViewModel: CoordinatorViewModel {
    weak var coordinator: ASKCoordinator.Coordinator?

    var phase: GameStatePhase = .menu

    private var cancellables: Set<AnyCancellable> = []

    @Resolvable<Resolver>
    init(mainStore: MainStore) {
        mainStore.$gameState.sink { [unowned self] in
            self.phase = $0.phase
        }
        .store(in: &cancellables)
    }

}
