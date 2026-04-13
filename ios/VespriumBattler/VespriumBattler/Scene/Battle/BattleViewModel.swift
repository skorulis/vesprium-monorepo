// Created by Alex Skorulis on 13/4/2026.

import ASKCoordinator
import Foundation
import Knit
import KnitMacros

@MainActor @Observable final class BattleViewModel: CoordinatorViewModel {
    weak var coordinator: ASKCoordinator.Coordinator?

    private let battleService: BattleService
    private let mainStore: MainStore

    private var model: BattleView.Model
    private var actionTimers = BattleActionTimers()

    @Resolvable<Resolver>
    init(battleService: BattleService, mainStore: MainStore) {
        self.battleService = battleService
        self.mainStore = mainStore

        let battle = battleService.makeBattle()
        self.model = .init(battle: battle)
        resetActionTimers()
    }

}

private extension BattleViewModel {

    func playerTick() {
        updateBattle { battle in
            battleService.playerTick(battle: &battle)
        }
    }

    func enemyTick(enemy: Enemy) {
        updateBattle { battle in
            battleService.enemyTick(battle: &battle, enemy: enemy)
        }
    }

    func battleTick() {
        updateBattle { battle in
            battleService.battleTick(battle: &battle)
        }
    }

    func updateBattle(_ mutation: (inout Battle) -> Void) {
        mutation(&model.battle)
        resetActionTimers()
    }

    func resetActionTimers() {
        actionTimers.reset(
            battle: model.battle,
            playerAction: { [weak self] in
                self?.playerTick()
            },
            enemyAction: { [weak self] enemy in
                self?.enemyTick(enemy: enemy)
            },
            battleAction: { [weak self] in
                self?.battleTick()
            }
        )
    }
}

private final class BattleActionTimers {

    private(set) var playerTimer: Timer?
    private(set) var enemyTimers: [UUID: Timer] = [:]
    private(set) var battleTimer: Timer?

    func reset(
        battle: Battle,
        playerAction: @escaping () -> Void,
        enemyAction: @escaping (Enemy) -> Void,
        battleAction: @escaping () -> Void
    ) {
        if playerTimer == nil {
            playerTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                playerAction()
            }
        }

        if battleTimer == nil {
            battleTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                battleAction()
            }
        }

        for enemy in battle.enemies {
            if enemyTimers[enemy.id] == nil {
                enemyTimers[enemy.id] = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    enemyAction(enemy)
                }
            }
        }

        for deadEnemy in battle.defeatedEnemies {
            if enemyTimers[deadEnemy.id] != nil {
                enemyTimers[deadEnemy.id]?.invalidate()
                enemyTimers.removeValue(forKey: deadEnemy.id)
            }
        }
    }

    deinit {
        playerTimer?.invalidate()
        battleTimer?.invalidate()
        enemyTimers.values.forEach { $0.invalidate() }
        playerTimer = nil
        battleTimer = nil
        enemyTimers = [:]
    }
}
