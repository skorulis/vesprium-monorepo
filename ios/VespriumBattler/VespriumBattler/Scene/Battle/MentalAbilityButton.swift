// Created by Alex Skorulis on 14/4/2026.

import Foundation
import SwiftUI

struct MentalAbilityButton: View {

    let ability: MentalAbility
    let cooldownRemaining: TimeInterval
    let action: () -> Void

    private var isReady: Bool { cooldownRemaining <= 0 }

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.ultraThinMaterial)

                ability.icon
                    .font(.headline)
                    .foregroundStyle(.primary)

                if cooldownFractionRemaining > 0 {
                    GeometryReader { proxy in
                        CooldownPieSlice(
                            fraction: cooldownFractionRemaining
                        )
                        .fill(.black.opacity(0.45))
                        .frame(width: proxy.size.width, height: proxy.size.height)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .frame(width: 54, height: 54)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(isReady ? .green.opacity(0.5) : .orange.opacity(0.6), lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
        .disabled(isReady == false)
        .accessibilityLabel(ability.rawValue.titleCase)
    }
}

private extension MentalAbilityButton {
    var cooldownFractionRemaining: Double {
        guard ability.cooldown > 0 else { return 0 }
        return min(1, max(0, cooldownRemaining / ability.cooldown))
    }
}

private extension String {
    var titleCase: String {
        unicodeScalars.reduce(into: "") { partialResult, scalar in
            if CharacterSet.uppercaseLetters.contains(scalar), partialResult.isEmpty == false {
                partialResult += " "
            }
            partialResult.append(String(scalar))
        }
        .capitalized
    }
}
