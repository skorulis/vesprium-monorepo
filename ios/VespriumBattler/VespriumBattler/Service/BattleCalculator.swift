// Created by Alex Skorulis on 13/4/2026.

import Foundation
import Util

struct BattleCalculator {

    func hitChance(attackerAgility: Int, defenderAgility: Int) -> Chance {
        let fraction = Double(attackerAgility) / Double(attackerAgility / 2 + defenderAgility)
        return Chance(fraction)
    }
}
