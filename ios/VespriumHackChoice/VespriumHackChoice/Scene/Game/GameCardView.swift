import SwiftUI

/// Renders a `GameCard` with a 2:1 aspect ratio: title, centered artwork, and a reserved footer for future metadata.
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
            Color.clear
                .frame(minHeight: GameCardView.footerReservedHeight)
                .accessibilityHidden(true)
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
        .accessibilityLabel(card.name)
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
