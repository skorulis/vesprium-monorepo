import SwiftUI

/// Renders a `GameCard` with title, centered artwork, and optional footer metadata (e.g. daily hours).
struct GameCardView: View {
    let card: GameCard
    /// When set, replaces ``GameCard/monthlyMoneyChange`` in the footer (e.g. job income from ``GameCalculator``).
    var monthlyMoneyChangeOverride: Int?
    /// When `true`, one-time purchase cost (e.g. body mods) is shown above the card, outside the border.
    var showsPrice: Bool = false

    private var effectiveMonthlyMoneyChange: Int {
        monthlyMoneyChangeOverride ?? card.monthlyMoneyChange
    }

    var body: some View {
        VStack(spacing: 8) {
            if showsPrice {
                Text("\(card.price) coins")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 150)
            }
            cardFace
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityTitle)
    }

    private var cardFace: some View {
        VStack(spacing: 12) {
            Text(card.name)
                .font(.headline)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.75)
                .frame(maxWidth: .infinity)
            Spacer()
            footer
        }
        .background {
            backgroundImage
        }
        .padding(12)
        .frame(width: 150, height: 225)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.background.secondary)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(borderColor, lineWidth: 1)
        }
    }

    @ViewBuilder
    private var footer: some View {
        if case .monthlyChoice(let option) = card {
            Text(option.hint)
                .font(.caption)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .minimumScaleFactor(0.8)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity)
        } else {
            HStack(spacing: 8) {
                maybeHours
                maybeMoney
                Spacer(minLength: 0)
            }
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
        }
    }

    @ViewBuilder
    private var maybeHours: some View {
        if card.dailyHours != 0 {
            HStack(spacing: 4) {
                Image(systemName: "clock.fill")
                    .font(.caption.weight(.semibold))
                    .imageScale(.small)
                Text("\(card.dailyHours)")
                    .font(.caption.monospacedDigit().weight(.medium))
            }
        }
    }

    @ViewBuilder
    private var maybeMoney: some View {
        if effectiveMonthlyMoneyChange != 0 {
            HStack(spacing: 4) {
                Image(systemName: "dollarsign.circle.fill")
                    .font(.caption.weight(.semibold))
                    .imageScale(.small)
                Text(moneyChangeLabel)
                    .font(.caption.monospacedDigit().weight(.medium))
            }
        }
    }

    private var borderColor: Color {
        switch card.type {
        case .job: return Color.blue.opacity(0.65)
        case .activity: return Color.purple.opacity(0.65)
        case .bodyEnhancement: return Color.teal.opacity(0.65)
        case .monthlyChoice: return Color.orange.opacity(0.75)
        }
    }

    private var moneyChangeLabel: String {
        let change = effectiveMonthlyMoneyChange
        if change > 0 {
            return "+\(change)"
        }
        return "\(change)"
    }

    private var accessibilityTitle: String {
        var parts: [String] = []
        if showsPrice, card.price > 0 {
            parts.append("\(card.price) coins")
        }
        parts.append(card.name)
        if case .monthlyChoice(let option) = card {
            parts.append(option.hint)
            return parts.joined(separator: ", ")
        }
        if card.dailyHours != 0 {
            parts.append("\(card.dailyHours) hours per day")
        }
        if effectiveMonthlyMoneyChange != 0 {
            parts.append("\(moneyChangeLabel) per month")
        }
        return parts.joined(separator: ", ")
    }

    private var backgroundImage: some View {
        card.icon
            .resizable()
            .scaledToFit()
            .symbolRenderingMode(.hierarchical)
            .frame(width: 64)
            .accessibilityHidden(true)
    }
}

#Preview("Job card") {
    HStack(spacing: 8) {
        GameCardView(card: .job(.farming))

        GameCardView(card: .activity(.school))
    }

}
