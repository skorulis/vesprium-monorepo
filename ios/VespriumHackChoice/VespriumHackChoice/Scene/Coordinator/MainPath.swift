import ASKCoordinator

enum MainPath: CoordinatorPath {
    case game

    var id: String {
        switch self {
        case .game:
            "game"
        }
    }
}
