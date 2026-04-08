import ASKCoordinator
import Knit
import SwiftUI

struct MainPathRenderer: CoordinatorPathRenderer {
    typealias PathType = MainPath

    let resolver: Resolver

    @MainActor @ViewBuilder
    func render(path: MainPath, in coordinator: Coordinator) -> some View {
        switch path {
        case .game:
            GameView(viewModel: resolver.gameViewModel())
        case .character:
            PlayerCharacterWrapperView(viewModel: resolver.playerCharacterWrapperViewModel())
        case .cards:
            PlayerCardsView(viewModel: coordinator.apply(resolver.playerCardsViewModel()))
        case let .cardDetails(card):
            CardDetailsView(viewModel: resolver.cardDetailsViewModel(card: card))
        }
    }
}
