// Created by Alex Skorulis on 14/4/2026.

import SwiftUI
import Util

struct BattlePlayerView: View {

    let battle: Battle

    private let calculator = BattleCalculator()

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.thinMaterial)

            VStack(spacing: 10) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.blue)
                
                physicalBurnoutGauge
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

            VStack(alignment: .trailing, spacing: 0) {
                Text("Hit: \(hitChanceText)")
                Text("DMG: \(damageText)")
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(.secondary)
            .padding(12)
        }
        .frame(height: 140)
    }

    private var physicalBurnoutGauge: some View {
        Gauge(value: battle.battlePlayer.physicalBurnoutFraction, in: 0...1) {
            EmptyView()
        } currentValueLabel: {
            Text("\(Int(battle.battlePlayer.physicalBurnoutFraction * 100))%")
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .tint(physicalBurnoutTint)
        .frame(width: 32, height: 32)
    }
}

private extension BattlePlayerView {

    var hitChanceText: String {
        guard let target = battle.enemies.first else {
            return "--"
        }

        return calculator
            .hitChance(
                attackerAgility: battle.battlePlayer.agility,
                defenderAgility: target.details.agility
            )
            .percentageString(decimalPlaces: 0)
    }

    var damageText: String {
        let damage = Double(battle.battlePlayer.player.damage) * battle.battlePlayer.averagedPhysicalExertion
        return "\(Int(round(damage)))"
    }

    var physicalBurnoutTint: Color? {
        let value = battle.battlePlayer.physicalBurnoutFraction
        if value >= 0.95 {
            return .red
        } else if value >= 0.9 {
            return .yellow
        }
        return nil
    }
}
