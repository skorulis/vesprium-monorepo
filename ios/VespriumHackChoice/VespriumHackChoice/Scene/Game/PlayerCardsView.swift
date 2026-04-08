import SwiftUI

/// Lists every card the player currently has equipped (job, activities, etc.).
struct PlayerCardsView: View {
    @State var viewModel: PlayerCardsViewModel
    var model: Model { viewModel.model }

    var body: some View {
        Group {
            if model.equippedCards.isEmpty {
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
                                            GameCardView(
                                                card: card,
                                                monthlyMoneyChangeOverride: model.monthlyMoneyChangeOverride(for: card)
                                            )
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

    /// Job first, then activities, then body modifications; empty types omitted.
    private var groupedCards: [(GameCardType, [GameCard])] {
        let jobs = model.equippedCards.filter { $0.type == .job }
        let activities = model.equippedCards.filter { $0.type == .activity }
        let bodyMods = model.equippedCards.filter { $0.type == .bodyEnhancement }
        var sections: [(GameCardType, [GameCard])] = []
        if !jobs.isEmpty { sections.append((.job, jobs)) }
        if !activities.isEmpty { sections.append((.activity, activities)) }
        if !bodyMods.isEmpty { sections.append((.bodyEnhancement, bodyMods)) }
        return sections
    }

    private func sectionTitle(for type: GameCardType) -> String {
        switch type {
        case .job: return "Job"
        case .activity: return "Activities"
        case .bodyEnhancement: return "Body modifications"
        }
    }
}

extension PlayerCardsView {
    struct Model {
        var player: PlayerCharacter

        var equippedCards: [GameCard] {
            player.cards.allCards
        }

        /// For job cards, monthly income from ``GameCalculator`` (includes attribute and enhancement bonuses).
        /// For other cards, `nil` so ``GameCardView`` uses ``GameCard/monthlyMoneyChange``.
        func monthlyMoneyChangeOverride(for card: GameCard) -> Int? {
            switch card {
            case .job(let job):
                return GameCalculator(player: player).monthlyJobEarnings(for: job)
            default:
                return nil
            }
        }
    }
}
