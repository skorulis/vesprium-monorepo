import ASKCoordinator

enum MainPath: CoordinatorPath {
    case game
    case character
    case cards

    var id: String {
        switch self {
        case .game:
            "game"
        case .character:
            "character"
        case .cards:
            "cards"
        }
    }
}
