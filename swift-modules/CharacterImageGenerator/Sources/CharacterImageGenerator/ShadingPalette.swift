//  Created by Alexander Skorulis on 4/4/2026.

import CoreGraphics

/// Flat fills plus slightly darker tones for seams between body regions (no faux 3D lighting).
struct CharacterShadingPalette: Sendable {
    let skinFlat: RGB
    /// Darker than ``skinFlat`` for 1px seams between head, neck, limbs, etc.
    let skinDivision: RGB
    let hairFlat: RGB
    let hairDivision: RGB
    let eye: RGB
    /// Darker ring around the iris for subtle eyelid / socket shading.
    let eyeShade: RGB
    let mouth: RGB

    init(skinBase: RGB, hairBase: RGB, eyeColor: RGB) {
        skinFlat = skinBase
        skinDivision = Self.mix(skinBase, Self.black, 0.30)
        hairFlat = hairBase
        hairDivision = Self.mix(hairBase, Self.black, 0.26)
        eye = eyeColor
        eyeShade = Self.mix(eyeColor, Self.black, 0.42)
        mouth = Self.mouthColor(skinBase: skinBase)
    }

    private static func mouthColor(skinBase: RGB) -> RGB {
        let a = Self.mix(skinBase, Self.black, 0.28)
        return RGB(
            r: min(255, UInt8(min(255, Int(a.r) + 8))),
            g: max(0, UInt8(max(0, Int(a.g) - 4))),
            b: max(0, UInt8(max(0, Int(a.b) - 2)))
        )
    }

    private static let black = RGB(r: 0, g: 0, b: 0)

    private static func mix(_ a: RGB, _ b: RGB, _ t: CGFloat) -> RGB {
        let t = min(max(t, 0), 1)
        return RGB(
            r: UInt8(round((1 - t) * CGFloat(a.r) + t * CGFloat(b.r))),
            g: UInt8(round((1 - t) * CGFloat(a.g) + t * CGFloat(b.g))),
            b: UInt8(round((1 - t) * CGFloat(a.b) + t * CGFloat(b.b)))
        )
    }
}
