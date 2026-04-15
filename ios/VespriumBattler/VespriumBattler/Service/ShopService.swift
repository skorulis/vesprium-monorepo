// Created by Alexander Skorulis on 15/4/2026.

import BioEnhancements
import BioStats
import Foundation
import Knit
import KnitMacros
import Util

final class ShopService {

    private let mainStore: MainStore

    @Resolvable<Resolver>
    init(mainStore: MainStore) {
        self.mainStore = mainStore
    }

    private var enhancementOptions: [ShopItem] {
        BioEnhancement.allCases.filter {
            if $0.isUseless { return false }
            if mainStore.player.enhancements.installed.contains($0) {
                return false
            }
            return true
        }
    }

    private var attributeTrainingOptions: [ShopItem] {
        Attribute.allCases.map {
            ShopView.TrainingOption(
                attribute: $0,
                amount: 1,
                cost: 40
            )
        }
    }

    private var abilityOptions: [ShopItem] {
        Ability.allCases.filter {
            $0.cost > 0 && !mainStore.player.mentalAbilities.contains($0)
        }
    }

    private func allShopOptions() -> [ShopItem] {
        return enhancementOptions + attributeTrainingOptions + abilityOptions
    }

    func createShopItems() -> [ShopItem] {
        var itemArray = RandomArray(items: allShopOptions()) { _ in
            1
        }

        var items: [ShopItem] = []
        var checkCount = 0
        while checkCount < 20 && items.count < 8 {
            checkCount += 1
            guard let (item, index) = itemArray.randomWithIndex else {
                continue
            }
            itemArray.remove(index: index)
            items.append(item)
        }

        return items
    }
}
