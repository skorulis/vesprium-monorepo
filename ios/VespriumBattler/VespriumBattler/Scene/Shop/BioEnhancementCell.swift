import BioStats
import BioEnhancements
import SwiftUI

/// Reusable presentation for a `BioEnhancement` with optional shop affordances.
public struct BioEnhancementCell: View {
    public let enhancement: BioEnhancement
    public let price: Int?
    public let actionTitle: String?
    public let isActionDisabled: Bool
    public let action: (() -> Void)?

    public init(
        enhancement: BioEnhancement,
        price: Int? = nil,
        actionTitle: String? = nil,
        isActionDisabled: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.enhancement = enhancement
        self.price = price
        self.actionTitle = actionTitle
        self.isActionDisabled = isActionDisabled
        self.action = action
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(enhancement.name)
                    .font(.headline)
                Spacer(minLength: 8)
                if let price {
                    Text(price, format: .number)
                        .font(.subheadline.monospacedDigit())
                        .foregroundStyle(.secondary)
                }
            }

            Text(enhancement.text)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if let grantedAbility = enhancement.grantedAbility {
                HStack(spacing: 8) {
                    Text("Grants")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    grantedAbility.icon
                    Text(grantedAbility.name)
                        .font(.subheadline)
                }
            }

            ShopItemBonusesView(item: enhancement)

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
