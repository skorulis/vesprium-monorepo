// Created by Alex Skorulis on 13/4/2026.

import ASKCoordinator
import Foundation
import SwiftUI

struct GameView {
    @State var viewModel: GameViewModel
    @Environment(\.resolver) private var resolver
}

extension GameView: View {
    var body: some View {
        switch viewModel.phase {
        case .menu:
            EmptyView()
        case .battle:
            BattleView(viewModel: applyCoordinator(resolver!.battleViewModel()))
        case .shop:
            ShopView(viewModel: applyCoordinator(resolver!.shopViewModel()))
        }
    }
    
    private func applyCoordinator<T>(_ viewModel: T) -> T {
        guard let coordinator = self.viewModel.coordinator else {
            return viewModel
        }
        return coordinator.apply(viewModel)
    }
}
