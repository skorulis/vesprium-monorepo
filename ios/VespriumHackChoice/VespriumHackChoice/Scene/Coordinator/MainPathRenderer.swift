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
            GameView(viewModel: coordinator.apply(resolver.gameViewModel()))
        case .character:
            PlayerCharacterView(viewModel: coordinator.apply(resolver.playerCharacterViewModel()))
        case .cards:
            PlayerCardsView(viewModel: coordinator.apply(resolver.playerCardsViewModel()))
        case let .cardDetails(card):
            CardDetailsView(viewModel: resolver.cardDetailsViewModel(card: card))
        case .monthlyExpensesBreakdown:
            MonthlyExpensesBreakdownView(viewModel: resolver.monthlyExpensesBreakdownViewModel())
        case .shop:
            ShopView(viewModel: coordinator.apply(resolver.shopViewModel()))
        }
    }
}
