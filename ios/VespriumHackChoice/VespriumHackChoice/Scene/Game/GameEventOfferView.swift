import SwiftUI

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
}
