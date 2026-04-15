// Created by Alex Skorulis on 13/4/2026.

import Knit
import KnitMacros
import Foundation
import Util

final class EnemyService {

    @Resolvable<Resolver>
    init() {}

    func make(battleLevel: Int) -> Enemy {
        let options = EnemyKind.allCases.filter { $0.details.startLevel <= battleLevel }
        let array = RandomArray(items: options, score: { $0.details.rarity })
        let type = array.random ?? .streetUrchin
        return .init(kind: type)
    }
}
