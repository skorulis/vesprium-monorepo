//  Created by Alexander Skorulis on 4/4/2026.

import CoreGraphics

/// Five-level skin ramp and four-level hair ramp for top-left lighting.
struct CharacterShadingPalette: Sendable {
    /// Order: highlight → light → mid → shadow → deep shadow.
    let skin: [RGB]
    /// Order: highlight → base → shadow → deep shadow.
    let hair: [RGB]
    let eye: RGB
    let mouth: RGB

    init(skinBase: RGB, hairBase: RGB, eyeColor: RGB) {
        skin = Self.skinRamp(from: skinBase)
        hair = Self.hairRamp(from: hairBase)
        eye = eyeColor
        mouth = Self.mouthColor(skinBase: skinBase)
    }

    /// `shadeT` 1 = top-left (brightest), 0 = bottom-right (darkest).
    func skin(at shadeT: CGFloat) -> RGB {
        let t = min(max(shadeT, 0), 1)
        let i = Int(round((1 - t) * CGFloat(skin.count - 1)))
        return skin[min(max(i, 0), skin.count - 1)]
    }

    /// Same convention as ``skin(at:)``.
    func hair(at shadeT: CGFloat) -> RGB {
        let t = min(max(shadeT, 0), 1)
        let i = Int(round((1 - t) * CGFloat(hair.count - 1)))
        return hair[min(max(i, 0), hair.count - 1)]
    }

    private static func skinRamp(from base: RGB) -> [RGB] {
        [
            mix(base, white, 0.38),
            mix(base, white, 0.16),
            base,
            mix(base, black, 0.24),
            mix(base, black, 0.46),
        ]
    }

    private static func hairRamp(from base: RGB) -> [RGB] {
        [
            mix(base, white, 0.28),
            base,
            mix(base, black, 0.26),
            mix(base, black, 0.48),
        ]
    }

    private static func mouthColor(skinBase: RGB) -> RGB {
        let a = mix(skinBase, black, 0.28)
        return RGB(
            r: min(255, UInt8(min(255, Int(a.r) + 8))),
            g: max(0, UInt8(max(0, Int(a.g) - 4))),
            b: max(0, UInt8(max(0, Int(a.b) - 2)))
        )
    }

    private static let white = RGB(r: 255, g: 255, b: 255)
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
