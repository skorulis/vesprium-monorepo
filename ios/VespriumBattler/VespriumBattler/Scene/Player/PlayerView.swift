// Created by Alex Skorulis on 14/4/2026.

import BioEnhancements
import BioStats
import Knit
import SwiftUI

struct PlayerView {
    @State var viewModel: PlayerViewModel
}

extension PlayerView: View {
    var body: some View {
        List {
            Section("Attributes") {
                ForEach(Attribute.allCases, id: \.self) { attribute in
                    LabeledContent(attribute.name) {
                        let base = viewModel.player.attributes[attribute]
                        let effective = viewModel.player.effectiveAttributes[attribute]
                        let delta = effective - base
                        Text("\(effective)")
                            .monospacedDigit()
                            .foregroundStyle(delta > 0 ? Color.green : delta < 0 ? Color.red : Color.primary)
                    }
                }
            }

            Section("Enhancements") {
                if viewModel.player.enhancements.installed.isEmpty {
                    Text("No enhancements installed.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(viewModel.player.enhancements.installed, id: \.rawValue) { enhancement in
                        BioEnhancementCell(enhancement: enhancement)
                    }
                }
            }

            Section("Abilities") {
                if viewModel.player.allAbilities.isEmpty {
                    Text("No abilities unlocked.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(viewModel.player.allAbilities, id: \.rawValue) { ability in
                        AbilityCell(ability: ability)
                    }
                }
            }
        }
        .navigationTitle("Player")
    }
}

#Preview {
    NavigationStack {
        let assembler = VespriumBattlerAssembly.testing()
        PlayerView(viewModel: assembler.resolver.playerViewModel())
    }
}
