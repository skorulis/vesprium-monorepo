//  Created by Alexander Skorulis on 5/4/2026.

import CoreGraphics

/// Face and head appearance for a generated character.
///
/// Proportion values use `0.5...1.5` with `1.0` as a neutral baseline.
public struct FaceParams: Equatable, Sendable {
    public var skinColor: RGB
    public var hairColor: RGB
    public var hairStyle: HairStyle
    /// Pixel color for both eyes. When omitted at initialization, a contrast‑aware default is chosen from ``skinColor``.
    public var eyeColor: RGB
    /// Scale for head width and height.
    public var headSize: CGFloat

    public init(
        skinColor: RGB = RGB(r: 220, g: 180, b: 150),
        hairColor: RGB = RGB(r: 60, g: 40, b: 25),
        hairStyle: HairStyle = .short,
        eyeColor: RGB? = nil,
        headSize: CGFloat = 1.0
    ) {
        self.skinColor = skinColor
        self.hairColor = hairColor
        self.hairStyle = hairStyle
        self.eyeColor = eyeColor ?? Self.defaultEyeColor(forSkin: skinColor)
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
