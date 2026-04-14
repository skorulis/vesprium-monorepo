// Created by Alex Skorulis on 14/4/2026.

import SwiftUI

struct FloatingDamageNumberView: View {

    let amount: Int

    @State private var yOffset: CGFloat = 0
    @State private var opacity: Double = 1
    @State private var scale: CGFloat = 0.9

    var body: some View {
        Text("\(amount)")
            .font(.headline.weight(.bold))
            .foregroundStyle(.red)
            .shadow(color: .black.opacity(0.35), radius: 2, x: 0, y: 1)
            .scaleEffect(scale)
            .offset(y: yOffset)
            .opacity(opacity)
            .onAppear {
                withAnimation(.spring(response: 0.2, dampingFraction: 0.65)) {
                    scale = 1.03
                }
                withAnimation(.easeOut(duration: 0.8)) {
                    yOffset = -24
                    opacity = 0
                }
            }
    }
}

#Preview("Floating Damage") {
    FloatingDamageNumberPreview()
}

private struct FloatingDamageNumberPreview: View {

    @State private var refreshID = UUID()

    var body: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.ultraThinMaterial)
                    .frame(width: 92, height: 62)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(.orange.opacity(0.6), lineWidth: 1.5)
                    )

                FloatingDamageNumberView(amount: 12)
                    .id(refreshID)
                    .offset(y: -8)
            }
            .padding(.top, 20)

            Button("Replay Animation") {
                refreshID = UUID()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
