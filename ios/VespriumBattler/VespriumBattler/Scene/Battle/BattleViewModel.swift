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

        let battle = battleService.makeBattle(level: mainStore.gameState.currentLevel)
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

    func selectTarget(enemyID: UUID) {
        updateBattle { battle in
            guard battle.enemies.contains(where: { $0.id == enemyID }) else { return }
            battle.targetedEnemyID = enemyID
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
        var enemyDamageByID: [UUID: Int] = [:]
        updateBattle { battle in
            let previousHealthByEnemyID = Dictionary(
                uniqueKeysWithValues: battle.enemies.map { ($0.id, $0.health) }
            )
            battle.battlePlayer.updateExertion(time: BattleActionTimers.playerTickTime)
            checkPhysicalBurnout(battle: &battle)
            battleService.playerTick(time: BattleActionTimers.playerTickTime, battle: &battle)

            for enemy in battle.enemies {
                guard let previousHealth = previousHealthByEnemyID[enemy.id] else { continue }
                let damage = previousHealth - enemy.health
                if damage > 0 {
                    enemyDamageByID[enemy.id] = damage
                }
            }
        }

        for (enemyID, damage) in enemyDamageByID {
            enqueueDamageEvent(enemyID: enemyID, amount: damage)
        }
    }

    func checkPhysicalBurnout(battle: inout Battle) {
        let chance = Chance(battle.battlePlayer.physicalBurnout.decayChance * BattleActionTimers.playerTickTime)
        if chance.check() {
            battle.battlePlayer.physicalBurnout.decayChance = 0
            let attribute: Attribute  = Chance(0.5).check() ? .strength : .agility
            battle.battlePlayer.player.attributes[attribute] -= 1
        }
    }

    func enemyTick() {
        var tickLength = BattleActionTimers.playerTickTime
        if model.battle.battlePlayer.activeAbilities[.focusSpike] != nil {
            tickLength *= 0.5
        }
        var playerDamageEvents: [Int] = []
        updateBattle { battle in
            let enemies = battle.enemies
            for var enemy in enemies {
                let previousPlayerHealth = battle.battlePlayer.health
                battleService.enemyTick(battle: &battle, enemy: &enemy, time: tickLength)
                battle.replace(enemy: enemy)
                let damage = previousPlayerHealth - battle.battlePlayer.health
                if damage > 0 {
                    playerDamageEvents.append(damage)
                }
            }
        }

        for damage in playerDamageEvents {
            enqueuePlayerDamageEvent(amount: damage)
        }
    }

    func battleTick() {
        updateBattle { battle in
            battleService.battleTick(battle: &battle)
        }
    }

    func updateBattle(_ mutation: (inout Battle) -> Void) {
        mutation(&model.battle)
        pruneDamageEventsForExistingEnemies()

        switch model.battle.state {
        case .lost:
            actionTimers.invalidateTimers()
            presentBattleOutcomeDialog(path: .battleLost)
        case .won:
            mainStore.player.addMoney(model.battle.level * 100)
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

    func enqueueDamageEvent(enemyID: UUID, amount: Int) {
        let event = DamageEvent(amount: amount)
        model.enemyDamageEvents[enemyID, default: []].append(event)

        Task { [weak self] in
            try? await Task.sleep(nanoseconds: 900_000_000)
            self?.removeDamageEvent(enemyID: enemyID, eventID: event.id)
        }
    }

    func removeDamageEvent(enemyID: UUID, eventID: UUID) {
        guard var events = model.enemyDamageEvents[enemyID] else { return }
        events.removeAll { $0.id == eventID }
        if events.isEmpty {
            model.enemyDamageEvents.removeValue(forKey: enemyID)
        } else {
            model.enemyDamageEvents[enemyID] = events
        }
    }

    func pruneDamageEventsForExistingEnemies() {
        let validEnemyIDs = Set(model.battle.enemies.map(\.id))
        model.enemyDamageEvents = model.enemyDamageEvents.filter { validEnemyIDs.contains($0.key) }
    }

    func enqueuePlayerDamageEvent(amount: Int) {
        let event = DamageEvent(amount: amount)
        model.playerDamageEvents.append(event)

        Task { [weak self] in
            try? await Task.sleep(nanoseconds: 900_000_000)
            self?.removePlayerDamageEvent(eventID: event.id)
        }
    }

    func removePlayerDamageEvent(eventID: UUID) {
        model.playerDamageEvents.removeAll { $0.id == eventID }
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
