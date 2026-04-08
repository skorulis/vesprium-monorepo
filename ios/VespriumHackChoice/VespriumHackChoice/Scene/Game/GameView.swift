import BioStats
import SwiftUI

struct GameView: View {
    @State var viewModel: GameViewModel

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(formattedDate(viewModel.gameState.currentGameDate))
                            .font(.headline.monospacedDigit())
                        Spacer(minLength: 0)
                        Text(viewModel.player.money, format: .number)
                            .font(.headline.monospacedDigit())
                            .accessibilityLabel("Money")
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    Spacer(minLength: 0)
                    Button {
                        viewModel.advanceTime()
                    } label: {
                        Image(systemName: "forward.circle.fill")
                            .font(.system(size: 120))
                            .symbolRenderingMode(.hierarchical)
                            .accessibilityLabel("Advance time")
                    }
                    .buttonStyle(.plain)
                    .disabled(viewModel.gameState.pendingEvent != nil || viewModel.gameState.pendingYearReview != nil)
                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                if let review = viewModel.gameState.pendingYearReview {
                    YearEndReviewView(review: review) {
                        viewModel.resolveYearReview()
                    }
                } else if let event = viewModel.gameState.pendingEvent {
                    GameEventOfferView(
                        event: event,
                        onSelectCard: { viewModel.resolvePendingEvent(selecting: $0) },
                        onSkip: { viewModel.resolvePendingEvent(selecting: nil) }
                    )
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        viewModel.exitToMenu()
                    } label: {
                        Image(systemName: "xmark.circle")
                    }
                    .accessibilityLabel("Exit to main menu")
                }
            }
        }
    }

    private func formattedDate(_ date: VespriumDate) -> String {
        "\(date.year) \(date.month.displayName) \(date.day)"
    }
}
