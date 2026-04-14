// Created by Alex Skorulis on 13/4/2026.

import ASKCoordinator
import BioEnhancements
import Combine
import Foundation
import Knit
import KnitMacros
import Util

@MainActor @Observable final class ShopViewModel: CoordinatorViewModel {
    weak var coordinator: ASKCoordinator.Coordinator?

    var model: ShopView.Model

    private let mainStore: MainStore

    private var cancellables: Set<AnyCancellable> = []

    @Resolvable<Resolver>
    init(mainStore: MainStore) {
        self.mainStore = mainStore

        var enhancementArray = RandomArray(items: BioEnhancement.allCases) {
            if mainStore.player.enhancements.installed.contains($0) {
                return 0
            }
            return 1
        }

        var items: [ShopView.ItemRow] = []
        var checkCount = 0
        while checkCount < 10 && items.count < 5 {
            checkCount += 1
            guard let (item, index) = enhancementArray.randomWithIndex else {
                continue
            }
            enhancementArray.remove(index: index)
            items.append(ShopView.ItemRow(enhancement: item))
        }

        self.model = ShopView.Model(
            player: mainStore.player,
            shopItems: items,
        )

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
