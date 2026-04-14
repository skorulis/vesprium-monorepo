// Created by Alex Skorulis on 13/4/2026.

import Knit
import Foundation
import SwiftUI

struct BattleView {

    @State var viewModel: BattleViewModel
    private var model: Model { viewModel.model }
}

extension BattleView: View {

    var body: some View {
        return ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                BattlePlayerView(
                    battle: model.battle,
                    damageEvents: model.playerDamageEvents
                )
                exertionSection
                enemySection
                mentalAbilitiesSection
                playerHealthSection
            }
            .padding(16)
        }
        .onAppear {
            viewModel.resetActionTimers()
        }
    }
}

private extension BattleView {

    var enemySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Enemies (\(model.battle.enemiesRemaining) remaining)")
                .font(.headline)

            if viewModel.enemies.isEmpty {
                Text("Waiting for enemies...")
                    .foregroundStyle(.secondary)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.enemies, id: \.id) { enemy in
                            EnemyChip(
                                enemy: enemy,
                                isTargeted: enemy.id == model.currentTargetedEnemyID,
                                damageEvents: model.damageEvents(for: enemy.id),
                                action: { viewModel.selectTarget(enemyID: enemy.id) }
                            )
                        }
                    }
                }
                .scrollClipDisabled(true)
            }
        }
    }

    var exertionSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Exertion")
                .font(.headline)

            LabeledSliderRow(
                title: "Physical",
                value: $viewModel.model.physicalExertion,
                range: 0...1.0
            )
        }
    }

    var mentalAbilitiesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Mental Abilities")
                .font(.headline)

            if viewModel.mentalAbilities.isEmpty {
                Text("No abilities unlocked")
                    .foregroundStyle(.secondary)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.mentalAbilities, id: \.self) { ability in
                            MentalAbilityButton(
                                ability: ability,
                                cooldownRemaining: viewModel.remainingCooldown(for: ability),
                                action: {
                                    viewModel.activate(ability)
                                }
                            )
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }

    var playerHealthSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Player Health")
                .font(.headline)

            ProgressView(value: playerHealthProgress)
                .progressViewStyle(.linear)

            Text("\(viewModel.playerHealth) / \(viewModel.playerMaxHealth)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    var playerHealthProgress: Double {
        guard viewModel.playerMaxHealth > 0 else { return 0 }
        return Double(viewModel.playerHealth) / Double(viewModel.playerMaxHealth)
    }
}

private struct LabeledSliderRow: View {

    let title: String
    @Binding var value: Double
    let range: ClosedRange<Double>

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                Spacer()
                Text("\(Int(value * 100))%")
                    .foregroundStyle(.secondary)
            }
            Slider(value: $value, in: range)
        }
    }
}

extension BattleView {
    struct Model {
        var battle: Battle
        var physicalExertion = 0.8
        var enemyDamageEvents: [UUID: [DamageEvent]] = [:]
        var playerDamageEvents: [DamageEvent] = []

        var currentTargetedEnemyID: UUID? {
            if let targetedEnemyID = battle.targetedEnemyID,
               battle.enemies.contains(where: { $0.id == targetedEnemyID }) {
                return targetedEnemyID
            }
            return battle.enemies.first?.id
        }

        func damageEvents(for enemyID: UUID) -> [DamageEvent] {
            enemyDamageEvents[enemyID] ?? []
        }
    }
}

#Preview {
    let assembler = VespriumBattlerAssembly.testing()
    BattleView(viewModel: assembler.resolver.battleViewModel())
}
