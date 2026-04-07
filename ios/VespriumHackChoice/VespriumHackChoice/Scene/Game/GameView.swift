import BioStats
import SwiftUI

struct GameView: View {
    @State var viewModel: GameViewModel

    var body: some View {
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
                viewModel.togglePlayback()
            } label: {
                Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 120))
                    .symbolRenderingMode(.hierarchical)
                    .accessibilityLabel(viewModel.isPlaying ? "Pause" : "Play")
            }
            .buttonStyle(.plain)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func formattedDate(_ date: VespriumDate) -> String {
        "\(date.year) \(date.month.displayName) \(date.day)"
    }
}
