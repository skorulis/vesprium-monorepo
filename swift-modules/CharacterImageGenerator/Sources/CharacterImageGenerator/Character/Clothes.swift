//  Created by Alexander Skorulis on 5/4/2026.

/// Clothing options that affect how the character is drawn. Omit a field (or pass `nil`) to leave that body region unchanged (e.g. skin for legs).
public struct Clothes: Equatable, Sendable {
    public var legWear: LegWear?
    public var topWear: TopWear?

    public init(legWear: LegWear? = nil, topWear: TopWear? = nil) {
        self.legWear = legWear
        self.topWear = topWear
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

/// Upper-body garment style for the sprite.
public enum TopWear: Equatable, Sendable, CaseIterable {
    /// Short sleeves; upper arms and torso use one fill.
    case tShirt
    /// Long sleeves to the wrist; hands stay skin tone.
    case shirt
    /// Sleeveless tank; torso covered, upper arms skin tone.
    case singlet
}
