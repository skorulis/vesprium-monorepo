// Created by Alex Skorulis on 13/4/2026.

import ASKCoordinator
import SwiftUI

struct BattleLostDialogView: View {
    @Environment(\.coordinator) private var coordinator

    var body: some View {
        VStack(spacing: 16) {
            Text("Defeat")
                .font(.title2.weight(.bold))

            Text("You were overwhelmed this battle.")
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
