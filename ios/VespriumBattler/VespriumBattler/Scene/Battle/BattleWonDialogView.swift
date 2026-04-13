// Created by Alex Skorulis on 13/4/2026.

import ASKCoordinator
import SwiftUI

struct BattleWonDialogView: View {
    @Environment(\.coordinator) private var coordinator

    var body: some View {
        VStack(spacing: 16) {
            Text("Victory")
                .font(.title2.weight(.bold))

            Text("All enemies have been defeated.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            Button("Continue") {
                coordinator?.retreat()
                coordinator?.retreat()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(8)
    }
}
