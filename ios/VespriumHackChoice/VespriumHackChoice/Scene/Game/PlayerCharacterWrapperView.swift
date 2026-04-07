import SwiftUI

/// Hosts ``PlayerCharacterView`` and mirrors ``MainStore`` so profile data stays current.
struct PlayerCharacterWrapperView: View {
    @State var viewModel: PlayerCharacterWrapperViewModel

    var body: some View {
        PlayerCharacterView(
            player: viewModel.player,
            currentGameDate: viewModel.gameState.currentGameDate
        )
    }
}
