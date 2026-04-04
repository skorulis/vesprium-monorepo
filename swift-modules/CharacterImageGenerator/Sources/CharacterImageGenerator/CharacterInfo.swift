import CoreGraphics

/// sRGB color for character rendering; components are `0...255`.
public struct RGB: Equatable, Sendable {
    public var r: UInt8
    public var g: UInt8
    public var b: UInt8

    public init(r: UInt8, g: UInt8, b: UInt8) {
        self.r = r
        self.g = g
        self.b = b
    }

    public func cgColor() -> CGColor {
        CGColor(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: 1
        )
    }
}

public enum Gender: Equatable, Sendable, CaseIterable {
    case male
    case female
    case unspecified
}

/// Describes visual parameters for a generated character.
///
/// Proportion values use `0.5...1.5` with `1.0` as a neutral baseline.
public struct CharacterInfo: Equatable, Sendable {
    public var gender: Gender
    public var skinColor: RGB
    public var hairColor: RGB
    /// Pixel color for both eyes. When omitted at initialization, a contrast‑aware default is chosen from ``skinColor``.
    public var eyeColor: RGB
    /// Vertical scale for legs and torso span.
    public var height: CGFloat
    /// Horizontal scale for torso and legs.
    public var weight: CGFloat
    /// Scale for arm length (from shoulder downward).
    public var armLength: CGFloat
    /// Scale for head width and height.
    public var headSize: CGFloat

    public init(
        gender: Gender = .unspecified,
        skinColor: RGB = RGB(r: 220, g: 180, b: 150),
        hairColor: RGB = RGB(r: 60, g: 40, b: 25),
        eyeColor: RGB? = nil,
        height: CGFloat = 1.0,
        weight: CGFloat = 1.0,
        armLength: CGFloat = 1.0,
        headSize: CGFloat = 1.0
    ) {
        self.gender = gender
        self.skinColor = skinColor
        self.hairColor = hairColor
        self.eyeColor = eyeColor ?? Self.defaultEyeColor(forSkin: skinColor)
        self.height = height
        self.weight = weight
        self.armLength = armLength
        self.headSize = headSize
    }

    /// Default eye pixels: darker on lighter skin for contrast, slightly softer on deeper skin tones.
    private static func defaultEyeColor(forSkin skin: RGB) -> RGB {
        let luminance =
            (CGFloat(skin.r) * 0.2126 + CGFloat(skin.g) * 0.7152 + CGFloat(skin.b) * 0.0722) / 255
        return luminance > 0.55
            ? RGB(r: 22, g: 18, b: 16)
            : RGB(r: 12, g: 10, b: 9)
    }
}
