import ASKCoordinator
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
                    if !viewModel.gameState.monthLog.isEmpty {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Recent months")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                                ForEach(Array(viewModel.gameState.monthLog.reversed().prefix(12)), id: \.date) { row in
                                    Text(monthLogLine(row))
                                        .font(.caption)
                                        .foregroundStyle(.primary)
                                        .multilineTextAlignment(.leading)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 8)
                        }
                        .frame(maxHeight: 200)
                    }
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
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.showJobs()
                    } label: {
                        Image(systemName: "briefcase")
                            .overlay(alignment: .topTrailing) {
                                if viewModel.player.job == nil {
                                    Circle()
                                        .fill(.red)
                                        .frame(width: 8, height: 8)
                                        .offset(x: 4, y: -4)
                                        .accessibilityHidden(true)
                                }
                            }
                    }
                    .accessibilityLabel("Open jobs")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.showShop()
                    } label: {
                        Image(systemName: "cart")
                    }
                    .accessibilityLabel("Open shop")
                }
            }
        }
    }

    private func formattedDate(_ date: VespriumDate) -> String {
        "\(date.year) \(date.month.displayName) \(date.day)"
    }

    private func monthLogLine(_ row: MonthSummary) -> String {
        var parts: [String] = []
        parts.append("\(row.date.year) \(row.date.month.displayName)")
        parts.append(row.moneyDelta >= 0 ? "+\(row.moneyDelta)" : "\(row.moneyDelta)")
        if let headline = row.eventHeadline {
            parts.append(headline)
        }
        if let choice = row.choiceSummary {
            parts.append("→ \(choice)")
        }
        return parts.joined(separator: " · ")
    }
}
