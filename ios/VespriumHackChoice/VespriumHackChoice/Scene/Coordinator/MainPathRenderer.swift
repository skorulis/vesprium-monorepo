import ASKCoordinator
import Knit
import SwiftUI

struct MainPathRenderer: CoordinatorPathRenderer {
    typealias PathType = MainPath
    typealias ViewType = GameView

    let resolver: Resolver

    @MainActor
    func render(path: MainPath, in coordinator: Coordinator) -> GameView {
        switch path {
        case .game:
            GameView(viewModel: resolver.gameViewModel())
        }
    }
}
