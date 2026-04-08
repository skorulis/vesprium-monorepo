import BioStats
import Foundation

/// Accumulators for the in-game calendar year (money and net stat changes).
struct CurrentYear: Codable, Sendable, Equatable {
    var moneyNetChange: Int
    var attributeIncreases: [Attribute: Int]

    static let zero = CurrentYear(moneyNetChange: 0, attributeIncreases: [:])
}

/// Snapshot shown when the player crosses into a new calendar year.
struct YearEndReview: Codable, Sendable, Equatable {
    var year: Int
    var totals: CurrentYear
}
