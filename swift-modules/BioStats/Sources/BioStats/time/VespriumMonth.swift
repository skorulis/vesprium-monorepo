/// Month within the Vesprium year (1…10); raw values match calendar ordinals.
public enum VespriumMonth: Int, Codable, CaseIterable, Hashable, Sendable {
    case thaw = 1
    case stir = 2
    case surge = 3
    case verdant = 4
    case haze = 5
    case ember = 6
    case dusk = 7
    case frost = 8
    case veil = 9
    case deep = 10

    /// Display name for UI and narrative.
    public var displayName: String {
        switch self {
        case .thaw: "Thaw"
        case .stir: "Stir"
        case .surge: "Surge"
        case .verdant: "Verdant"
        case .haze: "Haze"
        case .ember: "Ember"
        case .dusk: "Dusk"
        case .frost: "Frost"
        case .veil: "Veil"
        case .deep: "Deep"
        }
    }
}
