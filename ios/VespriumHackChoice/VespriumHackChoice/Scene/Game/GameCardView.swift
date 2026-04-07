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
        .frame(width: 180, height: 270)
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
        HStack(spacing: 4) {
            maybeHours

            Spacer()
        }
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var maybeHours: some View {
        if card.dailyHours != 0 {
            Image(systemName: "clock.fill")
                .font(.caption.weight(.semibold))
                .imageScale(.small)
            Text("\(card.dailyHours)")
                .font(.caption.monospacedDigit().weight(.medium))
        }

    }

    private var accessibilityTitle: String {
        if card.dailyHours > 0 {
            "\(card.name), \(card.dailyHours) hours per day"
        } else {
            card.name
        }
    }

    private var backgroundImage: some View {
        card.icon
            .resizable()
            .scaledToFit()
            .symbolRenderingMode(.hierarchical)
            .frame(width: 64)
            .accessibilityHidden(true)
    }

    /// Width ÷ height for the card face.
    private static let cardAspectRatio: CGFloat = 0.5

    /// Vertical space reserved for future bottom-row stats or labels.
    private static let footerReservedHeight: CGFloat = 36
}

#Preview("Job card") {
    GameCardView(card: .job(.farming))
        .padding()
        .frame(maxWidth: 320)
}
