// Created by Alex Skorulis on 13/4/2026.

import Knit
import KnitMacros
import Foundation

final class EnemyService {

    @Resolvable<Resolver>
    init() {}

    func make(battleLevel: Int) -> Enemy {
        return .init(kind: .rat)
    }
}
