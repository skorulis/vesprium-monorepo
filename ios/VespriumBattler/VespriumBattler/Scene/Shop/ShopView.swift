// Created by Alex Skorulis on 13/4/2026.

import BioEnhancements
import Knit
import SwiftUI

struct ShopView {
    @State var viewModel: ShopViewModel
}

extension ShopView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Money: \(viewModel.model.player.money)")
                    .font(.headline.monospacedDigit())
                Spacer()
                Button("Player") {
                    viewModel.showPlayer()
                }
                .buttonStyle(.bordered)
            }

            if viewModel.model.shopItems.isEmpty {
                Text("No new enhancements available.")
                    .foregroundStyle(.secondary)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.model.shopItems) { item in
                            itemCell(item: item)
                        }
                    }
                }
            }

            Button("Next Battle") {
                viewModel.goToNextBattle()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(16)
        .navigationTitle("Shop")
    }

    private func itemCell(item: ItemRow) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(item.enhancement.name)
                    .font(.headline)
                Spacer()
                Text("$\(item.enhancement.baseCost)")
                    .foregroundStyle(.secondary)
            }

            Text(item.enhancement.text)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack {
                Spacer()
                Button("Purchase") {
                    viewModel.purchase(item.enhancement)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.model.canPurchase(item: item))
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
        )
    }
}

extension ShopView {
    struct ItemRow: Identifiable {
        let enhancement: BioEnhancement

        var id: String { enhancement.rawValue }
    }

    struct Model {
        var player: PlayerCharacter
        var shopItems: [ItemRow]

        func canPurchase(item: ItemRow) -> Bool {
            return item.enhancement.baseCost <= player.money
        }
    }
}

#Preview {
    let assembler = VespriumBattlerAssembly.testing()
    ShopView(viewModel: assembler.resolver.shopViewModel())
}
