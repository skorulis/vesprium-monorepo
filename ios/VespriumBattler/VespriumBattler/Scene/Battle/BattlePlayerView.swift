// Created by Alex Skorulis on 14/4/2026.

import BioStats
import SwiftUI
import Util

struct BattlePlayerView: View {

    let battle: Battle
    let damageEvents: [DamageEvent]

    private let calculator = BattleCalculator()

    var body: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.thinMaterial)

            VStack(spacing: 10) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.blue)

                HStack(spacing: 30) {
                    physicalBurnoutGauge
                    mentalBurnoutGauge
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

            physicalInformation
        }
        .frame(height: 140)
        .overlay(alignment: .top) {
            ZStack {
                ForEach(Array(damageEvents.enumerated()), id: \.element.id) { index, event in
                    FloatingDamageNumberView(amount: event.amount)
                        .offset(y: CGFloat(20 + (index * 8)))
                }
            }
            .allowsHitTesting(false)
        }
    }

    private var physicalInformation: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Text("STR: \(player.effectiveAttributes[.strength])")
            Text("AGI: \(player.effectiveAttributes[.agility])")
            Text("HIT: \(hitChanceText)")
            Text("DMG: \(damageText)")
            AttackIndicatorView(fraction: attackProgressFraction)
        }
        .font(.caption.weight(.semibold))
        .foregroundStyle(.secondary)
        .padding(12)
    }

    private var physicalBurnoutGauge: some View {
        Gauge(value: battle.battlePlayer.physicalBurnoutFraction, in: 0...1) {
            EmptyView()
        } currentValueLabel: {
            Image(systemName: "figure.arms.open")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .tint(physicalBurnoutTint)
        .frame(width: 32, height: 32)
    }

    private var mentalBurnoutGauge: some View {
        Gauge(value: battle.battlePlayer.mentalBurnoutFraction, in: 0...1) {
            EmptyView()
        } currentValueLabel: {
            Image(systemName: "brain.head.profile.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .tint(mentalBurnoutTint)
        .frame(width: 32, height: 32)
    }
}

private extension BattlePlayerView {

    var player: PlayerCharacter { battle.battlePlayer.player }

    var hitChanceText: String {
        guard let chance = battle.playerHitChance else {
            return "--"
        }

        return chance.percentageString(decimalPlaces: 0)
    }

    var damageText: String {
        return "\(battle.battlePlayer.damage)"
    }

    var attackProgressFraction: Double {
        min(1, max(0, battle.battlePlayer.storedTime))
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

    var mentalBurnoutTint: Color? {
        let value = battle.battlePlayer.mentalBurnoutFraction
        if value >= 0.95 {
            return .red
        } else if value >= 0.9 {
            return .yellow
        }
        return nil
    }
}
