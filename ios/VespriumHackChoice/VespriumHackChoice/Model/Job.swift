/// Player profession; raw values are stable for persistence.
enum Job: String, Codable, CaseIterable, Hashable, Sendable {
    case farming
    case shopKeeper

    var name: String {
        String(describing: self).capitalized
    }

    /// Coins paid at the start of each in-game month while employed in this role.
    var monthlyIncome: Int {
        switch self {
        case .farming: 120
        case .shopKeeper: 100
        }
    }

    var dailyHours: Int {
        switch self {
        case .farming: 10
        case .shopKeeper: 10
        }
    }
}
