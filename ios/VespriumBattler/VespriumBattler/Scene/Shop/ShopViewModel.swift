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
            items.append(ShopView.ItemRow(id: UUID(), option: .enhancement(item)))
        }

        for attribute in Attribute.allCases.shuffled().prefix(2) {
            let training = ShopView.TrainingOption(
                attribute: attribute,
                amount: 1,
                cost: 40
            )
            items.append(ShopView.ItemRow(id: UUID(), option: .training(training)))
        }

        self.model = ShopView.Model(
            player: mainStore.player,
            shopItems: items.shuffled(),
        )

        mainStore.$player.sink { [unowned self] in
            self.model.player = $0
        }
        .store(in: &cancellables)
    }
}

// MARK: - Actions

extension ShopViewModel {

    func purchase(_ item: ShopView.ItemRow) {
        switch item.option {
        case let .enhancement(enhancement):
            purchaseEnhancement(enhancement)
        case let .training(training):
            purchaseTraining(training)
        }
        model.shopItems = model.shopItems.filter { $0.id == item.id }
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

    func goToNextBattle() {
        mainStore.gameState.currentLevel += 1
        mainStore.gameState.phase = .battle
    }

    func showPlayer() {
        coordinator?.push(MainPath.player)
    }
}
