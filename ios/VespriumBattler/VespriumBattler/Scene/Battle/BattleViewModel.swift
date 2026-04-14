// Created by Alex Skorulis on 13/4/2026.

import ASKCoordinator
import BioStats
import Foundation
import Knit
import KnitMacros
import Util

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

    var mentalAbilities: [MentalAbility] {
        model.battle.battlePlayer.player.mentalAbilities
    }

    func remainingCooldown(for ability: MentalAbility) -> TimeInterval {
        model.battle.battlePlayer.abilityCooldowns[ability] ?? 0
    }

    func canActivate(_ ability: MentalAbility) -> Bool {
        remainingCooldown(for: ability) <= 0
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

    func activate(_ ability: MentalAbility) {
        guard canActivate(ability) else { return }
        updateBattle { battle in
            battle.battlePlayer.activate(ability: ability)
        }
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
            checkPhysicalBurnout(battle: &battle)
            battleService.playerTick(time: BattleActionTimers.playerTickTime, battle: &battle)
        }
    }

    func checkPhysicalBurnout(battle: inout Battle) {
        let chance = Chance(battle.battlePlayer.physicalBurnoutChance)
        if chance.check() {
            battle.battlePlayer.physicalBurnoutChance = 0
            let attribute: Attribute  = Chance(0.5).check() ? .strength : .agility
            battle.battlePlayer.player.attributes[attribute] -= 1
        }
    }

    func enemyTick() {
        var tickLength = BattleActionTimers.playerTickTime
        if model.battle.battlePlayer.activeAbilities[.focusSpike] != nil {
            tickLength *= 0.5
        }
        updateBattle { battle in
            let enemies = battle.enemies
            for var enemy in enemies {
                battleService.enemyTick(battle: &battle, enemy: &enemy, time: tickLength)
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
