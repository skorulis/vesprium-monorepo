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
            Text("Money: \(viewModel.player.money)")
                .font(.headline.monospacedDigit())

            if viewModel.shopItems.isEmpty {
                Text("No new enhancements available.")
                    .foregroundStyle(.secondary)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.shopItems) { item in
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
                                    .disabled(item.canPurchase == false)
                                }
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.ultraThinMaterial)
                            )
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
}

#Preview {
    let assembler = VespriumBattlerAssembly.testing()
    ShopView(viewModel: assembler.resolver.shopViewModel())
}
