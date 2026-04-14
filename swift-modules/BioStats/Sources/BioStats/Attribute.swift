/// Registry of character statistics for the world model.
///
/// Add new cases here as concrete statistics are defined; raw values stay stable for persistence.
public enum Attribute: String, Codable, CaseIterable, Hashable, Sendable, CustomStringConvertible {

    /// Raw physical power: lifting, striking, and sustained exertion.
    case strength

    /// Speed, coordination, and fine motor control—how quickly and precisely the body moves.
    case agility

    /// Reasoning, memory, and learning—capacity to analyze, plan, and absorb new information.
    case cognition

    /// Robust health and staying power: endurance, recovery, and resistance to illness or fatigue.
    case vitality

    /// Social presence and influence: persuasion, empathy, leadership, and how others respond to the character.
    case charisma

    /// Coherence of body and mind under stress—resilience to shock, integration strain, and destabilizing change.
    case stability

    public static let defaultValue: Int = 10

    public var name: String {
        rawValue.capitalized
    }

    public var description: String { name }
}
