// Created by Alex Skorulis on 13/4/2026.

import ASKCoordinator
import Knit
import SwiftUI

enum MainPath: CoordinatorPath {
    case battle
    case mainMenu
    case shop
    case battleWon
    case battleLost

    var id: String {
        switch self {
        case .battle:
            return "battle"
        case .mainMenu:
            return "mainMenu"
        case .shop:
            return "shop"
        case .battleWon:
            return "battleWon"
        case .battleLost:
            return "battleLost"
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
        case .shop:
            ShopView(viewModel: coordinator.apply(resolver.shopViewModel()))
        case .battleWon:
            BattleWonDialogView()
        case .battleLost:
            BattleLostDialogView()
        }
    }
}
