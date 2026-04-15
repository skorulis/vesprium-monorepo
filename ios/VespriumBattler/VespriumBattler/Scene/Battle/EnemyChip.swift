// Created by Alex Skorulis on 14/4/2026.

import Foundation
import SwiftUI

struct EnemyChip: View {

    let enemy: Enemy
    let isTargeted: Bool
    let damageEvents: [DamageEvent]
    let action: () -> Void

    private var cooldownRemainingFraction: Double {
        let attackRate = enemy.details.attackRate
        guard attackRate > 0 else { return 0 }
        let remaining = max(0, attackRate - enemy.storedTime)
        return min(1, max(0, remaining / attackRate))
    }

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 6) {
                Text(enemy.kind.rawValue.capitalized)
                    .font(.subheadline.weight(.semibold))
                Text("HP \(enemy.health)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(width: 92, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.ultraThinMaterial)
            )
            .overlay {
                if cooldownRemainingFraction > 0 {
                    CooldownPieView(remainingFraction: cooldownRemainingFraction)
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(isTargeted ? .red : .orange.opacity(0.6), lineWidth: isTargeted ? 2 : 1.5)
            )
            .overlay(alignment: .top) {
                ZStack {
                    ForEach(Array(damageEvents.enumerated()), id: \.element.id) { index, event in
                        FloatingDamageNumberView(amount: event.amount)
                            .offset(y: CGFloat(-2 - (index * 6)))
                    }
                }
                .allowsHitTesting(false)
                .zIndex(10)
            }
        }
        .buttonStyle(.plain)
    }
}
