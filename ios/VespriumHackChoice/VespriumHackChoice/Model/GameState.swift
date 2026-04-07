import BioStats

/// Simulation state that is not part of the player character: calendar, economy phase,
/// world flags, and other shared runtime data should live here rather than on ``PlayerCharacter``.
struct GameState: Codable, Sendable, Equatable {
    /// In-game “today,” used with ``PlayerCharacter/dateOfBirth`` for age and time-based rules.
    var currentGameDate: VespriumDate
    /// When set, the simulation pauses until the player resolves this event.
    var pendingEvent: GameEvent? = nil
}
