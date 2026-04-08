import SwiftUI

/// Hosts ``PlayerCharacterView`` and mirrors ``MainStore`` so profile data stays current.
struct PlayerCharacterWrapperView: View {
    @State var viewModel: PlayerCharacterWrapperViewModel

    var body: some View {
        PlayerCharacterView(
            player: viewModel.model.player,
            currentGameDate: viewModel.model.gameState.currentGameDate,
            monthlyBalanceChange: viewModel.model.monthlyBalanceChange
        )
    }
}

extension PlayerCharacterWrapperView {
    struct Model {
        var gameState: GameState
        var player: PlayerCharacter

        var monthlyBalanceChange: Int {
            GameCalculator(player: player).monthlyBalanceChange()
        }
    }
}
