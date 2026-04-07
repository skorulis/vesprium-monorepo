import SwiftUI

/// Renders a `GameCard` with title, centered artwork, and optional footer metadata (e.g. daily hours).
struct GameCardView: View {
    let card: GameCard

    var body: some View {
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
                .strokeBorder(.separator.opacity(0.35), lineWidth: 1)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityTitle)
    }

    @ViewBuilder
    private var footer: some View {
        HStack(spacing: 8) {
            maybeHours
            maybeMoney
            Spacer(minLength: 0)
        }
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity)
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
        if card.monthlyMoneyChange != 0 {
            HStack(spacing: 4) {
                Image(systemName: "dollarsign.circle.fill")
                    .font(.caption.weight(.semibold))
                    .imageScale(.small)
                Text(moneyChangeLabel)
                    .font(.caption.monospacedDigit().weight(.medium))
            }
        }
    }

    private var moneyChangeLabel: String {
        let change = card.monthlyMoneyChange
        if change > 0 {
            return "+\(change)"
        }
        return "\(change)"
    }

    private var accessibilityTitle: String {
        var parts: [String] = [card.name]
        if card.dailyHours != 0 {
            parts.append("\(card.dailyHours) hours per day")
        }
        if card.monthlyMoneyChange != 0 {
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
