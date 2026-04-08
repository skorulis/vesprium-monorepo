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
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(groupedCards, id: \.0) { type, cards in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(sectionTitle(for: type))
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.secondary)
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(Array(cards.enumerated()), id: \.offset) { _, card in
                                            GameCardView(card: card)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    /// Job first, then activities; empty types omitted.
    private var groupedCards: [(GameCardType, [GameCard])] {
        let jobs = viewModel.equippedCards.filter { $0.type == .job }
        let activities = viewModel.equippedCards.filter { $0.type == .activity }
        var sections: [(GameCardType, [GameCard])] = []
        if !jobs.isEmpty { sections.append((.job, jobs)) }
        if !activities.isEmpty { sections.append((.activity, activities)) }
        return sections
    }

    private func sectionTitle(for type: GameCardType) -> String {
        switch type {
        case .job: return "Job"
        case .activity: return "Activities"
        }
    }
}
