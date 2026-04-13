import BioStats

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

    var incomeBonuses: [Attribute: Int] {
        switch self {
        case .farming:
            return [.strength: 2, .vitality: 2]
        case .shopKeeper:
            return [.charisma: 2, .cognition: 2]
        }
    }

    var dailyHours: Int {
        switch self {
        case .farming: 10
        case .shopKeeper: 10
        }
    }

    var flags: JobFlag {
        switch self {
        case .farming:
            return [.outdoors]
        case .shopKeeper:
            return []
        }
    }
}

struct JobFlag: OptionSet {
    let rawValue: UInt

    static let outdoors = Self(rawValue: 1 << 0)

}
