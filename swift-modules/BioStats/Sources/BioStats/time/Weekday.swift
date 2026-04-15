/// One day in the seven-day week; order is the cycle order (``CaseIterable``).
public enum Weekday: Int, Codable, CaseIterable, Hashable, Sendable {
    case forge = 0
    case weave = 1
    case graft = 2
    case pulse = 3
    case bloom = 4
    case still = 5
    case mend = 6

    /// Display name for UI and narrative.
    public var displayName: String {
        switch self {
        case .forge: "Forge"
        case .weave: "Weave"
        case .graft: "Graft"
        case .pulse: "Pulse"
        case .bloom: "Bloom"
        case .still: "Still"
        case .mend: "Mend"
        }
    }
}
