// Created by Alex Skorulis on 13/4/2026.

import ASKCoordinator
import BioEnhancements
import BioStats
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
    init(mainStore: MainStore, shopService: ShopService) {
        self.mainStore = mainStore
        self.model = ShopView.Model(
            nextLevel: mainStore.gameState.currentLevel + 1,
            player: mainStore.player,
            shopItems: shopService.createShopItems().shuffled(),
        )

        mainStore.$player.sink { [unowned self] in
            self.model.player = $0
        }
        .store(in: &cancellables)
    }
}

// MARK: - Actions

extension ShopViewModel {

    func purchase(_ item: ShopItem) {
        if let enhancement = item as? BioEnhancement {
            purchaseEnhancement(enhancement)
        } else if let training = item as? ShopView.TrainingOption {
            purchaseTraining(training)
        } else if let ability = item as? Ability {

        } else {
            fatalError("Unexpected item \(item)")
        }

        model.shopItems = model.shopItems.filter { $0.id != item.id }
    }

    private func purchaseEnhancement(_ enhancement: BioEnhancement) {
        guard model.player.enhancements.installed.contains(enhancement) == false else { return }
        guard model.player.money >= enhancement.baseCost else { return }

        var player = mainStore.player
        player.money -= enhancement.baseCost
        player.enhancements.installed.append(enhancement)
        mainStore.player = player
    }

    private func purchaseTraining(_ training: ShopView.TrainingOption) {
        guard model.player.money >= training.cost else { return }

        var player = mainStore.player
        player.money -= training.cost
        player.attributes[training.attribute] += training.amount
        mainStore.player = player
    }

    private func purchaseAbility(_ ability: Ability) {
        guard model.player.money >= ability.cost else { return }

        var player = mainStore.player
        player.money -= ability.cost
        player.mentalAbilities.append(ability)
        mainStore.player = player
    }

    func goToNextBattle() {
        mainStore.gameState.currentLevel += 1
        mainStore.gameState.phase = .battle
    }

    func showPlayer() {
        coordinator?.push(MainPath.player)
    }
}
