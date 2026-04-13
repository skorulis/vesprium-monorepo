// Created by Alex Skorulis on 13/4/2026.

import ASKCoordinator
import SwiftUI

struct BattleWonDialogView: View {
    @Environment(\.coordinator) private var coordinator
    let mainStore: MainStore

    var body: some View {
        VStack(spacing: 16) {
            Text("Victory")
                .font(.title2.weight(.bold))

            Text("All enemies have been defeated.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            Button("Visit Shop") {
                coordinator?.dismissOverlay()
                mainStore.gameState.phase = .shop
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(8)
    }
}
