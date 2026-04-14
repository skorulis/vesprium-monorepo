// Created by Alex Skorulis on 13/4/2026.

import BioEnhancements
import BioStats
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
                Text("No new options available.")
                    .foregroundStyle(.secondary)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.model.shopItems) { item in
                            optionCell(item: item)
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

    private func optionCell(item: ItemRow) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(item.title)
                    .font(.headline)
                Spacer()
                Text("$\(item.cost)")
                    .foregroundStyle(.secondary)
            }

            Text(item.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack {
                Spacer()
                Button("Purchase") {
                    viewModel.purchase(item)
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
    enum ShopOption {
        case enhancement(BioEnhancement)
        case training(TrainingOption)

        var id: String {
            switch self {
            case let .enhancement(enhancement):
                return "enhancement-\(enhancement.rawValue)"
            case let .training(training):
                return "training-\(training.attribute.rawValue)-\(training.amount)-\(training.cost)"
            }
        }

        var title: String {
            switch self {
            case let .enhancement(enhancement):
                return enhancement.name
            case let .training(training):
                return training.name
            }
        }

        var description: String {
            switch self {
            case let .enhancement(enhancement):
                return enhancement.text
            case let .training(training):
                return training.text
            }
        }

        var cost: Int {
            switch self {
            case let .enhancement(enhancement):
                return enhancement.baseCost
            case let .training(training):
                return training.cost
            }
        }

        func canPurchase(player: PlayerCharacter) -> Bool {
            guard player.money >= cost else { return false }
            switch self {
            case let .enhancement(enhancement):
                return player.enhancements.installed.contains(enhancement) == false
            case .training:
                return true
            }
        }
    }

    struct TrainingOption {
        let attribute: Attribute
        let amount: Int
        let cost: Int

        var name: String {
            "Training: \(attribute.name)"
        }

        var text: String {
            "Permanently increases \(attribute.name.lowercased()) by \(amount)."
        }
    }

    struct ItemRow: Identifiable {
        let id: UUID
        let option: ShopOption

        var title: String { option.title }
        var description: String { option.description }
        var cost: Int { option.cost }
    }

    struct Model {
        var player: PlayerCharacter
        var shopItems: [ItemRow]

        func canPurchase(item: ItemRow) -> Bool {
            item.option.canPurchase(player: player)
        }
    }
}

#Preview {
    let assembler = VespriumBattlerAssembly.testing()
    ShopView(viewModel: assembler.resolver.shopViewModel())
}
