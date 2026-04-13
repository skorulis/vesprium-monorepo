// Created by Alex Skorulis on 13/4/2026.

import ASKCoordinator
import Knit
import SwiftUI

enum MainPath: CoordinatorPath {
    case game
    case battle
    case mainMenu
    case shop
    case player
    case battleWon
    case battleLost

    var id: String {
        switch self {
        case .game:
            return "game"
        case .battle:
            return "battle"
        case .mainMenu:
            return "mainMenu"
        case .shop:
            return "shop"
        case .player:
            return "player"
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
        case .game:
            GameView(viewModel: coordinator.apply(resolver.gameViewModel()))
        case .battle:
            BattleView(viewModel: coordinator.apply(resolver.battleViewModel()))
        case .mainMenu:
            MainMenuView(viewModel: coordinator.apply(resolver.mainMenuViewModel()))
        case .shop:
            ShopView(viewModel: coordinator.apply(resolver.shopViewModel()))
        case .player:
            PlayerView(viewModel: coordinator.apply(resolver.playerViewModel()))
        case .battleWon:
            BattleWonDialogView(mainStore: resolver.mainStore())
        case .battleLost:
            BattleLostDialogView()
        }
    }
}
