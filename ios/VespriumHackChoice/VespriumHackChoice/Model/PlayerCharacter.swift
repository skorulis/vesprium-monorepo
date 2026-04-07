import BioStats
import Foundation

struct PlayerCharacter: Codable, Sendable, Equatable {
    var attributes: AttributeValues
    var money: Int
    var job: Job
    var dateOfBirth: Date

    init(
        attributes: AttributeValues = AttributeValues(),
        money: Int = 0,
        job: Job = .farming,
        dateOfBirth: Date
    ) {
        self.attributes = attributes
        self.money = money
        self.job = job
        self.dateOfBirth = dateOfBirth
    }

    /// Full years elapsed since ``dateOfBirth`` relative to `currentGameDate` (Gregorian).
    func ageInFullYears(
        on currentGameDate: Date,
        calendar: Calendar = Calendar(identifier: .gregorian)
    ) -> Int {
        let birth = calendar.startOfDay(for: dateOfBirth)
        let now = calendar.startOfDay(for: currentGameDate)
        guard now >= birth else { return 0 }

        let parts = calendar.dateComponents([.year, .month, .day], from: birth, to: now)
        guard let years = parts.year else { return 0 }
        let month = parts.month ?? 0
        let day = parts.day ?? 0
        if month < 0 || (month == 0 && day < 0) {
            return max(0, years - 1)
        }
        return max(0, years)
    }
}
