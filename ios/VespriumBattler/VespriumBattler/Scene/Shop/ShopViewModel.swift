// Created by Alex Skorulis on 13/4/2026.

import ASKCoordinator
import BioEnhancements
import Combine
import Foundation
import Knit
import KnitMacros

@MainActor @Observable final class ShopViewModel: CoordinatorViewModel {
    weak var coordinator: ASKCoordinator.Coordinator?

    var model: ShopView.Model
    
    private let mainStore: MainStore
    
    private var cancellables: Set<AnyCancellable> = []

    @Resolvable<Resolver>
    init(mainStore: MainStore) {
        self.mainStore = mainStore
        self.model = ShopView.Model(player: mainStore.player)
        
        mainStore.$player.sink { [unowned self] in
            self.model.player = $0
        }
        .store(in: &cancellables)
    }
}

// MARK: - Actions

extension ShopViewModel {

    func purchase(_ enhancement: BioEnhancement) {
        guard model.player.enhancements.installed.contains(enhancement) == false else { return }
        guard model.player.money >= enhancement.baseCost else { return }

        var player = mainStore.player
        player.money -= enhancement.baseCost
        player.enhancements.installed.append(enhancement)
        mainStore.player = player
    }

    func goToNextBattle() {
        mainStore.gameState.phase = .battle
    }

    func showPlayer() {
        coordinator?.push(MainPath.player)
    }
}
