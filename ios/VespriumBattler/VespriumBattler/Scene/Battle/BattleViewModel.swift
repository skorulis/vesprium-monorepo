// Created by Alex Skorulis on 13/4/2026.

import ASKCoordinator
import Foundation
import Knit
import KnitMacros

@MainActor @Observable final class BattleViewModel: CoordinatorViewModel {
    weak var coordinator: ASKCoordinator.Coordinator?

    private let battleService: BattleService
    private let mainStore: MainStore

    var model: BattleView.Model
    private var actionTimers = BattleActionTimers()
    private var hasPresentedBattleOutcomeDialog = false

    @Resolvable<Resolver>
    init(battleService: BattleService, mainStore: MainStore) {
        self.battleService = battleService
        self.mainStore = mainStore

        let battle = battleService.makeBattle()
        self.model = .init(battle: battle)
    }

    var enemies: [Enemy] {
        model.battle.enemies
    }

    var playerHealth: Int {
        model.battle.battlePlayer.health
    }

    var playerMaxHealth: Int {
        model.battle.battlePlayer.player.maxHealth
    }
}

// MARK: - Actions

extension BattleViewModel {
    func resetActionTimers() {
        actionTimers.reset(
            battle: model.battle,
            attackAction: { [weak self] in
                self?.attackTick()
            },
            battleAction: { [weak self] in
                self?.battleTick()
            }
        )
    }
}

// MARK: - Logic

private extension BattleViewModel {

    func attackTick() {
        playerTick()
        enemyTick()
    }

    func playerTick() {
        let physicalExertion = model.physicalExertion
        updateBattle { battle in
            battle.battlePlayer.updateExertion(
                physical: physicalExertion,
                time: BattleActionTimers.playerTickTime
            )
            battleService.playerTick(time: BattleActionTimers.playerTickTime, battle: &battle)
        }
    }

    func enemyTick() {
        updateBattle { battle in
            let enemies = battle.enemies
            for var enemy in enemies {
                battleService.enemyTick(battle: &battle, enemy: &enemy, time: BattleActionTimers.playerTickTime)
                battle.replace(enemy: enemy)
            }
        }
    }

    func battleTick() {
        updateBattle { battle in
            battleService.battleTick(battle: &battle)
        }
    }

    func updateBattle(_ mutation: (inout Battle) -> Void) {
        mutation(&model.battle)

        switch model.battle.state {
        case .lost:
            actionTimers.invalidateTimers()
            presentBattleOutcomeDialog(path: .battleLost)
        case .won:
            actionTimers.invalidateTimers()
            presentBattleOutcomeDialog(path: .battleWon)
        default:
            resetActionTimers()
        }
    }

    func presentBattleOutcomeDialog(path: MainPath) {
        guard hasPresentedBattleOutcomeDialog == false else { return }
        hasPresentedBattleOutcomeDialog = true
        coordinator?.custom(overlay: .basicDialog, path)
    }
}

private final class BattleActionTimers {

    private(set) var attackTimer: Timer?
    private(set) var battleTimer: Timer?

    fileprivate static let playerTickTime: TimeInterval = 0.1

    func reset(
        battle: Battle,
        attackAction: @escaping () -> Void,
        battleAction: @escaping () -> Void
    ) {
        if attackTimer == nil {
            attackTimer = Timer.scheduledTimer(withTimeInterval: Self.playerTickTime, repeats: true) { _ in
                attackAction()
            }
        }

        if battleTimer == nil {
            battleTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                battleAction()
            }
        }
    }

    func invalidateTimers() {
        attackTimer?.invalidate()
        battleTimer?.invalidate()
        attackTimer = nil
        battleTimer = nil
    }

    deinit {
        invalidateTimers()
    }
}
