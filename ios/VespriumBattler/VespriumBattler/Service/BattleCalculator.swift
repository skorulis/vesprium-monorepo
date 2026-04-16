// Created by Alex Skorulis on 13/4/2026.

import Foundation
import Util

struct BattleCalculator {

    func hitChance(attackerAgility: Int, defenderAgility: Int, reflexSpeed: Double) -> Chance {
        let totalDefence = Double(defenderAgility) * reflexSpeed
        let agi = Double(attackerAgility)
        let fraction = agi / (agi * 0.5 + totalDefence)
        return Chance(fraction)
    }
}
