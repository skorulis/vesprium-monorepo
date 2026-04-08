import ASKCoordinator

enum MainPath: CoordinatorPath {
    case game
    case character
    case cards
    case cardDetails(GameCard)

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
        }
    }
}
