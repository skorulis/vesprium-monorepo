import SwiftUI

struct GameEventOfferView: View {
    let event: GameEvent
    let onSelectCard: (GameCard) -> Void
    let onSkip: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()
            VStack(spacing: 20) {
                Text(event.text)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(event.cards.indices, id: \.self) { index in
                            let card = event.cards[index]
                            Button {
                                onSelectCard(card)
                            } label: {
                                GameCardView(
                                    card: card,
                                    showsPrice: event.cards.contains { $0.showsPurchasePriceInOffer }
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 4)
                }
                if event.skippable {
                    Button("Skip", role: .cancel) {
                        onSkip()
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding(24)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.background)
            }
            .padding(20)
        }
    }
}
