import ASKCoordinator

enum MainPath: CoordinatorPath {
    case content

    var id: String {
        switch self {
        case .content:
            "content"
        }
    }
}
