import SwiftUI

struct GameEventOfferView: View {
    @State var viewModel: GameEventOfferViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.event.text)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.event.cards.indices, id: \.self) { index in
                        let card = viewModel.event.cards[index]
                        Button {
                            viewModel.selectCard(card)
                        } label: {
                            GameCardView(
                                card: card,
                                showsPrice: viewModel.event.cards.contains { $0.showsPurchasePriceInOffer }
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 4)
            }
            if viewModel.event.skippable {
                Button("Skip", role: .cancel) {
                    viewModel.skip()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(24)
    }
}
