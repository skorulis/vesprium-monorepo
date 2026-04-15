// Created by Alex Skorulis on 15/4/2026.

import Foundation
import BioStats
import BioEnhancements

protocol ShopItem: EntityBoost {
    var cost: Int { get }
    var grantedAbility: Ability? { get }
}

extension ShopItem {
    func canPurchase(player: PlayerCharacter) -> Bool {
        guard player.money >= cost else { return false }
        if let enhancement = self as? BioEnhancement {
            if player.enhancements.isUnavailable(enhancement) {
                return false
            }
            return player.enhancements.installed.contains(enhancement) == false
        }
        return true
    }
}

extension BioEnhancement: ShopItem {
    var cost: Int { baseCost }
}
