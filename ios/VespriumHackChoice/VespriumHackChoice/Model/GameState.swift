import BioEnhancements
import BioStats

/// Simulation state that is not part of the player character: calendar, economy phase,
/// world flags, and other shared runtime data should live here rather than on ``PlayerCharacter``.
struct GameState: Sendable, Equatable, Codable {
    /// In-game “today,” used with ``PlayerCharacter/dateOfBirth`` for age and time-based rules.
    var currentGameDate: VespriumDate
    /// When set, the simulation pauses until the player resolves this event.
    var pendingEvent: GameEvent?
    /// Running totals for the current Vesprium calendar year (reset after year-end review).
    var currentYear: CurrentYear
    /// When set, the player must dismiss the year summary before other pending events run.
    var pendingYearReview: YearEndReview?
    /// Recent months for the on-screen log (newest last; capped in ``GameService``).
    var monthLog: [MonthSummary]
    /// Current yearly shop inventory of bio enhancements.
    var shopEnhancements: [BioEnhancement]
    /// Last year when shop inventory was refreshed.
    var shopLastRefreshYear: Int?

    init(
        currentGameDate: VespriumDate,
        pendingEvent: GameEvent? = nil,
        currentYear: CurrentYear = .zero,
        pendingYearReview: YearEndReview? = nil,
        monthLog: [MonthSummary] = [],
        shopEnhancements: [BioEnhancement] = Self.defaultShopEnhancements(),
        shopLastRefreshYear: Int? = nil
    ) {
        self.currentGameDate = currentGameDate
        self.pendingEvent = pendingEvent
        self.currentYear = currentYear
        self.pendingYearReview = pendingYearReview
        self.monthLog = monthLog
        self.shopEnhancements = shopEnhancements
        self.shopLastRefreshYear = shopLastRefreshYear
    }

    static func defaultShopEnhancements() -> [BioEnhancement] {
        let all = BioEnhancement.allCases
        let count = min(3, all.count)
        return Array(all.shuffled().prefix(count))
    }
}
