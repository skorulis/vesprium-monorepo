import BioStats
import SwiftUI

/// Reusable presentation for a `MentalAbility` with optional shop affordances.
struct MentalAbilityCell: View {
    let ability: MentalAbility
    let price: Int?
    let actionTitle: String?
    let isActionDisabled: Bool
    let action: (() -> Void)?

    init(
        ability: MentalAbility,
        price: Int? = nil,
        actionTitle: String? = nil,
        isActionDisabled: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.ability = ability
        self.price = price
        self.actionTitle = actionTitle
        self.isActionDisabled = isActionDisabled
        self.action = action
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                HStack(spacing: 8) {
                    ability.icon
                    Text(ability.name)
                        .font(.headline)
                }
                Spacer(minLength: 8)
                if let price {
                    Text(price, format: .number)
                        .font(.subheadline.monospacedDigit())
                        .foregroundStyle(.secondary)
                }
            }

            Text(ability.text)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            LabeledContent("Duration", value: "\(Int(ability.duration))s")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            ShopItemBonusesView(item: ability)

            if let actionTitle, let action {
                HStack {
                    Spacer()
                    Button(actionTitle) {
                        action()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isActionDisabled)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
