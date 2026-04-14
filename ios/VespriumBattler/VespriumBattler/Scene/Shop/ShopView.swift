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
            .padding(16)

            if viewModel.model.shopItems.isEmpty {
                Text("No new options available.")
                    .foregroundStyle(.secondary)
            } else {
                itemList
            }

            continueButton
        }

        .navigationTitle("Shop")
    }

    private var itemList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(viewModel.model.shopItems) { item in
                    optionCell(item: item)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private var continueButton: some View {
        HStack {
            Spacer()
            Button("Continue to battle \(viewModel.model.nextLevel)") {
                viewModel.goToNextBattle()
            }
            .buttonStyle(.borderedProminent)
        }
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

            bonuses(item: item)

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

    private func bonuses(item: ItemRow) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(item.attributeBonusText, id: \.self) { text in
                Text(text)
                    .font(.caption)
            }

            ForEach(item.derivedAttributeBoostsText, id: \.self) { text in
                Text(text)
                    .font(.caption)
            }

            ForEach(item.strainIncreaseText, id: \.self) { text in
                Text(text)
                    .font(.caption)
            }
        }
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

        var attributeBonuses: [AttributeBonus] {
            switch self {
            case let .enhancement(enhancement):
                return enhancement.attributeBonuses
            case let .training(training):
                return training.attributeBonuses
            }
        }

        var derivedAttributeBonuses: [DerivedAttributeBonus] {
            switch self {
            case let .enhancement(enhancement):
                return enhancement.derivedAttributeBonuses
            case .training:
                return []
            }
        }

        var strain: Strain {
            switch self {
            case let .enhancement(enhancement):
                return enhancement.strain
            case .training:
                return .none
            }
        }

        func canPurchase(player: PlayerCharacter) -> Bool {
            guard player.money >= cost else { return false }
            switch self {
            case let .enhancement(enhancement):
                if player.enhancements.isUnavailable(enhancement) {
                    return false
                }
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

        var attributeBonuses: [AttributeBonus] {
            [AttributeBonus(attribute: attribute, value: amount)]
        }
    }

    struct ItemRow: Identifiable {
        let id: UUID
        let option: ShopOption

        var title: String { option.title }
        var description: String { option.description }
        var cost: Int { option.cost }
        var attributeBonuses: [AttributeBonus] { option.attributeBonuses }
        var derivedAttributeBonuses: [DerivedAttributeBonus] { option.derivedAttributeBonuses }
        var strain: Strain { option.strain }
        var attributeBonusText: [String] {
            attributeBonuses.map { $0.description }
        }

        var derivedAttributeBoostsText: [String] {
            derivedAttributeBonuses.map { $0.description }
        }

        var strainIncreaseText: [String] { strain.descriptionLines }

    }

    struct Model {
        let nextLevel: Int
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
