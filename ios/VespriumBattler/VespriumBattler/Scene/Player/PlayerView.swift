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
                        VStack(alignment: .leading, spacing: 4) {
                            Text(enhancement.name)
                                .font(.headline)
                            Text(enhancement.text)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }

            Section("Abilities") {
                if viewModel.player.mentalAbilities.isEmpty {
                    Text("No abilities unlocked.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(viewModel.player.mentalAbilities, id: \.rawValue) { ability in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 8) {
                                ability.icon
                                Text(ability.rawValue.titleCase)
                            }
                            .font(.headline)

                            Text(ability.text)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            LabeledContent("Duration", value: "\(Int(ability.duration))s")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            ForEach(ability.strain.descriptionLines, id: \.self) { line in
                                Text(line)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("Player")
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

#Preview {
    NavigationStack {
        let assembler = VespriumBattlerAssembly.testing()
        PlayerView(viewModel: assembler.resolver.playerViewModel())
    }
}
