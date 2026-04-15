// Created by Alex Skorulis on 15/4/2026.

import SwiftUI

struct AttackIndicatorView: View {

    let fraction: Double

    private var clampedFraction: Double {
        min(1, max(0, fraction))
    }

    var body: some View {
        ZStack {
            Image(systemName: "star.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.secondary.opacity(0.25))

            Image(systemName: "star.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.red)
                .mask {
                    GeometryReader { proxy in
                        VStack(spacing: 0) {
                            Spacer(minLength: 0)
                            Rectangle()
                                .frame(height: proxy.size.height * clampedFraction)
                        }
                    }
                }
        }
        .frame(width: 32, height: 32)
        .accessibilityLabel("Attack charge")
        .accessibilityValue("\(Int(clampedFraction * 100)) percent")
    }
}
