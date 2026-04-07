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
    
    var job: Job? {
        return cards.job
    }
}
