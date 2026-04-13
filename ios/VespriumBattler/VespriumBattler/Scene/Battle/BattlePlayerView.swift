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
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

            VStack(alignment: .trailing, spacing: 4) {
                Text("Hit: \(hitChanceText)")
                Text("DMG: \(damageText)")
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(.secondary)
            .padding(12)
        }
        .frame(height: 140)
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
}
