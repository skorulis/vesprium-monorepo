import ASKCoordinator

enum MainPath: CoordinatorPath {
    case game
    case character
    case cards
    case cardDetails(GameCard)
    case monthlyExpensesBreakdown
    case shop
    case job

    var id: String {
        switch self {
        case .game:
            "game"
        case .character:
            "character"
        case .cards:
            "cards"
        case .cardDetails:
            "cardDetails"
        case .monthlyExpensesBreakdown:
            "monthlyExpensesBreakdown"
        case .shop:
            "shop"
        case .job:
            "job"
        }
    }
}
