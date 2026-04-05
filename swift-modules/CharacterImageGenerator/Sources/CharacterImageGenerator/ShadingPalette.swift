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

    /// Denim-like fill for ``LegWear/pants``.
    let pantsFlat: RGB
    let pantsDivision: RGB
    /// Khaki fill for ``LegWear/shorts``.
    let shortsFlat: RGB
    let shortsDivision: RGB

    /// Cotton tee fill for ``TopWear/tShirt``.
    let tShirtFlat: RGB
    let tShirtDivision: RGB
    /// Woven shirt fill for ``TopWear/shirt``.
    let shirtFlat: RGB
    let shirtDivision: RGB

    init(skinBase: RGB, hairBase: RGB, eyeColor: RGB) {
        skinFlat = skinBase
        skinDivision = Self.mix(skinBase, Self.black, 0.30)
        hairFlat = hairBase
        hairDivision = Self.mix(hairBase, Self.black, 0.26)
        eye = eyeColor
        eyeShade = Self.mix(eyeColor, Self.black, 0.42)
        mouth = Self.mouthColor(skinBase: skinBase)

        pantsFlat = Self.pantsBase
        pantsDivision = Self.mix(Self.pantsBase, Self.black, 0.26)
        shortsFlat = Self.shortsBase
        shortsDivision = Self.mix(Self.shortsBase, Self.black, 0.26)

        tShirtFlat = Self.tShirtBase
        tShirtDivision = Self.mix(Self.tShirtBase, Self.black, 0.22)
        shirtFlat = Self.dressShirtBase
        shirtDivision = Self.mix(Self.dressShirtBase, Self.black, 0.24)
    }

    func topWearFlat(_ top: TopWear) -> RGB {
        switch top {
        case .tShirt: return tShirtFlat
        case .shirt: return shirtFlat
        }
    }

    func topWearDivision(_ top: TopWear) -> RGB {
        switch top {
        case .tShirt: return tShirtDivision
        case .shirt: return shirtDivision
        }
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
    private static let pantsBase = RGB(r: 55, g: 75, b: 120)
    private static let shortsBase = RGB(r: 210, g: 165, b: 95)
    private static let tShirtBase = RGB(r: 228, g: 228, b: 232)
    private static let dressShirtBase = RGB(r: 198, g: 212, b: 235)

    private static func mix(_ a: RGB, _ b: RGB, _ t: CGFloat) -> RGB {
        let t = min(max(t, 0), 1)
        return RGB(
            r: UInt8(round((1 - t) * CGFloat(a.r) + t * CGFloat(b.r))),
            g: UInt8(round((1 - t) * CGFloat(a.g) + t * CGFloat(b.g))),
            b: UInt8(round((1 - t) * CGFloat(a.b) + t * CGFloat(b.b)))
        )
    }
}
