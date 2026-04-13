// Created by Alex Skorulis on 13/4/2026.

import ASKCoordinator
import BioEnhancements
import Foundation
import Knit
import KnitMacros

@MainActor @Observable final class ShopViewModel: CoordinatorViewModel {
    weak var coordinator: ASKCoordinator.Coordinator?

    private let mainStore: MainStore

    @Resolvable<Resolver>
    init(mainStore: MainStore) {
        self.mainStore = mainStore
    }
}

extension ShopViewModel {
    struct ItemRow: Identifiable {
        let enhancement: BioEnhancement
        let canAfford: Bool

        var id: String { enhancement.rawValue }
        var canPurchase: Bool { canAfford }
    }

    var player: PlayerCharacter {
        mainStore.player
    }

    var shopItems: [ItemRow] {
        Array(BioEnhancement.allCases
            .filter { player.enhancements.installed.contains($0) == false }
            .prefix(5))
            .map { enhancement in
                ItemRow(
                    enhancement: enhancement,
                    canAfford: player.money >= enhancement.baseCost
                )
            }
    }

    func purchase(_ enhancement: BioEnhancement) {
        guard player.enhancements.installed.contains(enhancement) == false else { return }
        guard player.money >= enhancement.baseCost else { return }

        var player = mainStore.player
        player.money -= enhancement.baseCost
        player.enhancements.installed.append(enhancement)
        mainStore.player = player
    }

    func goToNextBattle() {
        mainStore.gameState.phase = .battle
    }
}
