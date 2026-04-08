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

    init(
        currentGameDate: VespriumDate,
        pendingEvent: GameEvent? = nil,
        currentYear: CurrentYear = .zero,
        pendingYearReview: YearEndReview? = nil
    ) {
        self.currentGameDate = currentGameDate
        self.pendingEvent = pendingEvent
        self.currentYear = currentYear
        self.pendingYearReview = pendingYearReview
    }
}
