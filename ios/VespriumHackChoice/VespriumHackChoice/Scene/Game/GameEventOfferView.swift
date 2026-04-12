import SwiftUI
import BioStats

struct GameEventOfferView: View {
    @State var viewModel: GameEventOfferViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.event.text)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)

            mainContent

            if viewModel.event.skippable {
                Button("Skip", role: .cancel) {
                    viewModel.skip()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(24)
    }

    private var mainContent: some View {
        switch viewModel.event.kind {
        case .cards(let array):
            cardContent(array)
        case .attributeTrade(let from, let to, let amount):
            tradeContent(from: from, to: to, amount: amount)
        }
    }

    private func cardContent(_ cards: [GameCard]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(cards.indices, id: \.self) { index in
                    let card = cards[index]
                    Button {
                        viewModel.selectCard(card)
                    } label: {
                        GameCardView(
                            card: card,
                            showsPrice: cards.contains { $0.showsPurchasePriceInOffer }
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 4)
        }
    }

    private func tradeContent(from: Attribute, to: Attribute, amount: Int) -> some View {
        VStack(spacing: 14) {
            HStack(spacing: 10) {
                attributeTradeRow(attribute: from, amountText: "-\(amount)", tint: .red)
                Image(systemName: "arrow.right")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                attributeTradeRow(attribute: to, amountText: "+\(amount)", tint: .green)
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.secondary.opacity(0.12))
            }

            Button("Apply Trade") {
                viewModel.acceptTrade()
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private func attributeTradeRow(attribute: Attribute, amountText: String, tint: Color) -> some View {
        VStack(spacing: 4) {
            Text(attribute.name)
                .font(.subheadline.weight(.medium))
            Text(amountText)
                .font(.headline.monospacedDigit())
                .foregroundStyle(tint)
        }
        .frame(maxWidth: .infinity)
    }
}
