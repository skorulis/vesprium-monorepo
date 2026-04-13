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
                enemySection
                exertionSection
                burnoutSection
                playerHealthSection
            }
            .padding(16)
        }
    }
}

private extension BattleView {

    var enemySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Enemies")
                .font(.headline)

            if viewModel.enemies.isEmpty {
                Text("Waiting for enemies...")
                    .foregroundStyle(.secondary)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.enemies, id: \.id) { enemy in
                            EnemyChip(enemy: enemy)
                        }
                    }
                    .padding(.vertical, 4)
                }
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
                range: 0...1
            )
            LabeledSliderRow(
                title: "Mental",
                value: $viewModel.model.mentalExertion,
                range: 0...1
            )
        }
    }

    var burnoutSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Burnout")
                .font(.headline)

            LabeledGaugeRow(
                title: "Physical Burnout",
                value: model.physicalBurnout,
                range: 0...1
            )
            LabeledGaugeRow(
                title: "Mental Burnout",
                value: model.mentalBurnout,
                range: 0...1
            )
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

private struct EnemyChip: View {

    let enemy: Enemy

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(enemy.kind.rawValue.capitalized)
                .font(.subheadline.weight(.semibold))
            Text("HP \(enemy.health)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
        )
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

private struct LabeledGaugeRow: View {

    let title: String
    let value: Double
    let range: ClosedRange<Double>

    var body: some View {
        HStack {
            Gauge(value: value, in: range) {
                Text(title)
            } currentValueLabel: {
                Text("\(Int(value * 100))%")
            }
            .gaugeStyle(.linearCapacity)
        }
    }
}

extension BattleView {
    struct Model {
        var battle: Battle
        var physicalExertion = 0.8
        var mentalExertion = 0.0
        var physicalBurnout = 0.0
        var mentalBurnout = 0.0
    }
}

#Preview {
    let assembler = VespriumBattlerAssembly.testing()
    BattleView(viewModel: assembler.resolver.battleViewModel())
}
