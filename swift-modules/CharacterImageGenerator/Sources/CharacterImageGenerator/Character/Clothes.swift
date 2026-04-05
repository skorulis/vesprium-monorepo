//  Created by Alexander Skorulis on 5/4/2026.

/// Clothing options that affect how the character is drawn. Omit a field (or pass `nil`) to leave that body region unchanged (e.g. skin for legs).
public struct Clothes: Equatable, Sendable {
    public var legWear: LegWear?

    public init(legWear: LegWear? = nil) {
        self.legWear = legWear
    }
    
    static func nude() -> Clothes {
        .init()
    }
}

/// Lower-body garment style for the sprite.
public enum LegWear: Equatable, Sendable, CaseIterable {
    /// Ends partway down the thigh; lower leg uses skin tone.
    case shorts
    /// Covers each leg down to the ankle.
    case pants
}
