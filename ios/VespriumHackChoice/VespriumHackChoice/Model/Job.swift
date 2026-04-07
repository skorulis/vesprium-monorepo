/// Player profession; raw values are stable for persistence.
enum Job: String, Codable, CaseIterable, Hashable, Sendable {
    case farming

    var name: String {
        String(describing: self).capitalized
    }

    /// Coins paid at the start of each in-game month while employed in this role.
    var monthlyIncome: Int {
        switch self {
        case .farming: 120
        }
    }
    
    var dailyHours: Int {
        switch self {
        case .farming: 10
        }
    }
}
