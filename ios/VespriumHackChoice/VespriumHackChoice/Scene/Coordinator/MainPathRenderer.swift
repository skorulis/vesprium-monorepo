import ASKCoordinator
import Knit
import SwiftUI

struct MainPathRenderer: CoordinatorPathRenderer {
    typealias PathType = MainPath
    typealias ViewType = MainPathContentView

    let resolver: Resolver

    @MainActor
    func render(path: MainPath, in coordinator: Coordinator) -> MainPathContentView {
        MainPathContentView(path: path, resolver: resolver)
    }
}

struct MainPathContentView: View {
    let path: MainPath
    let resolver: Resolver

    var body: some View {
        switch path {
        case .game:
            GameView(viewModel: resolver.gameViewModel())
        case .character:
            PlayerCharacterWrapperView(viewModel: resolver.playerCharacterWrapperViewModel())
        case .cards:
            PlayerCardsView(viewModel: resolver.playerCardsViewModel())
        }
    }
}
