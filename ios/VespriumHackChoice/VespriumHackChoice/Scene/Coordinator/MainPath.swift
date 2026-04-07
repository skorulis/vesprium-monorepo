import ASKCoordinator

enum MainPath: CoordinatorPath {
    case game
    case character

    var id: String {
        switch self {
        case .game:
            "game"
        case .character:
            "character"
        }
    }
}
