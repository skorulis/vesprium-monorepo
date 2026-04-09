import BioStats

struct PlayerCharacter: Codable, Sendable, Equatable {
    var attributes: AttributeValues
    var money: Int
    var dateOfBirth: VespriumDate
    var cards: PlayerCards

    init(
        attributes: AttributeValues = AttributeValues(),
        money: Int = 200,
        dateOfBirth: VespriumDate
    ) {
        self.attributes = attributes
        self.money = money
        self.dateOfBirth = dateOfBirth
        self.cards = .init()
    }

    /// Full Vesprium calendar years completed since ``dateOfBirth`` relative to `currentGameDate`.
    func ageInFullYears(on currentGameDate: VespriumDate) -> Int {
        guard currentGameDate >= dateOfBirth else { return 0 }
        var years = currentGameDate.year - dateOfBirth.year
        let birthMonth = dateOfBirth.month.rawValue
        let nowMonth = currentGameDate.month.rawValue
        if nowMonth < birthMonth
            || (nowMonth == birthMonth && currentGameDate.day < dateOfBirth.day) {
            years -= 1
        }
        return max(0, years)
    }

    /// Full calendar months since the last completed birthday (after ``ageInFullYears``), relative to `currentGameDate`.
    func ageExtraMonths(on currentGameDate: VespriumDate) -> Int {
        guard currentGameDate >= dateOfBirth else { return 0 }
        let years = ageInFullYears(on: currentGameDate)
        let anniversary = dateOfBirth.adding(years: years)
        guard currentGameDate >= anniversary else { return 0 }
        return currentGameDate.daysSince(anniversary) / VespriumCalendar.daysPerMonth
    }

    var job: Job? {
        return cards.job
    }
    
    /// Base attribute values with all equipped body enhancement bonuses applied.
    var effectiveAttributes: AttributeValues {
        attributes.applyingBonuses(cards.equippedAttributeBonuses)
    }
}
