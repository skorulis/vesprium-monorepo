import SwiftUI

/// Lists every card the player currently has equipped (job, activities, etc.).
struct PlayerCardsView: View {
    @State var viewModel: PlayerCardsViewModel

    var body: some View {
        Group {
            if viewModel.equippedCards.isEmpty {
                ContentUnavailableView(
                    "No cards equipped",
                    systemImage: "rectangle.stack",
                    description: Text("Take a job or add activities to see cards here.")
                )
            } else {
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 160), spacing: 12)],
                        spacing: 16
                    ) {
                        ForEach(viewModel.equippedCards.indices, id: \.self) { index in
                            GameCardView(card: viewModel.equippedCards[index])
                        }
                    }
                    .padding()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
