// Created by Alex Skorulis on 13/4/2026.

import ASKCoordinator
import Knit
import SwiftUI

enum MainPath: CoordinatorPath {
    case battle
    case mainMenu

    var id: String {
        switch self {
        case .battle:
            return "battle"
        case .mainMenu:
            return "mainMenu"
        }
    }
}

struct MainPathRenderer: CoordinatorPathRenderer {
    typealias PathType = MainPath

    let resolver: Resolver

    @MainActor @ViewBuilder
    func render(path: MainPath, in coordinator: Coordinator) -> some View {
        switch path {
        case .battle:
            BattleView(viewModel: coordinator.apply(resolver.battleViewModel()))
        case .mainMenu:
            MainMenuView(viewModel: coordinator.apply(resolver.mainMenuViewModel()))
        }
    }
}
