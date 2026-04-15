// Created by Alex Skorulis on 14/4/2026.

import BioStats
import Knit
import SwiftUI
import Util

struct BattlePlayerView: View {

    let battle: Battle
    let damageEvents: [DamageEvent]

    private let calculator = BattleCalculator()

    var body: some View {
        HStack(alignment: .top) {
            physicalInformation
            
            Spacer()
            
            VStack(spacing: 10) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.blue)
            }
            
            Spacer()

            mentalInformation
        }
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.thinMaterial)
        )
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
        VStack(alignment: .leading, spacing: 0) {
            physicalBurnoutGauge
                .padding(.bottom, 20)
            
            Text("STR: \(player.effectiveAttributes[.strength])")
            Text("AGI: \(battlePlayer.agility)")
            Text("HIT: \(hitChanceText)")
            Text("DMG: \(battle.battlePlayer.damage)")
            AttackIndicatorView(fraction: attackProgressFraction)
            
        }
        .font(.caption.weight(.semibold))
        .padding(12)
    }
    
    private var mentalInformation: some View {
        VStack(alignment: .trailing, spacing: 0) {
            mentalBurnoutGauge
                .padding(.bottom, 20)
            Text("COG: \(player.effectiveAttributes[.cognition])")
            Text("STA: \(player.effectiveAttributes[.stability])")
        }
        .font(.caption.weight(.semibold))
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

    var battlePlayer: BattlePlayer { battle.battlePlayer }
    var player: PlayerCharacter { battle.battlePlayer.player }

    var hitChanceText: String {
        guard let chance = battle.playerHitChance else {
            return "--"
        }

        return chance.percentageString(decimalPlaces: 0)
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

#Preview {
    let assembler = VespriumBattlerAssembly.testing()
    BattlePlayerView(
        battle: assembler.resolver.battleService().makeBattle(level: 1),
        damageEvents: []
    )
    .padding()
}
