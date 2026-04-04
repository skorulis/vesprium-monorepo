//  Created by Alexander Skorulis on 4/4/2026.

import CoreGraphics
import Foundation

// MARK: - Shared drawing & layout math

func fillRect(
    _ context: CGContext,
    x: Int,
    y: Int,
    width: Int,
    height: Int,
    color: RGB
) {
    guard width > 0, height > 0 else { return }
    context.setFillColor(color.cgColor())
    context.fill(CGRect(x: x, y: y, width: width, height: height))
}

func fillPixel(_ context: CGContext, x: Int, y: Int, color: RGB) {
    fillRect(context, x: x, y: y, width: 1, height: 1, color: color)
}

/// Light from the top-left: `1` = bright corner, `0` = dark opposite corner.
func shadeTTopLeft(px: Int, py: Int, width: Int, height: Int) -> CGFloat {
    let w = max(width, 1)
    let h = max(height, 1)
    let denomX = max(w - 1, 1)
    let denomY = max(h - 1, 1)
    let lx = CGFloat(px) / CGFloat(denomX)
    let ty = CGFloat(py) / CGFloat(denomY)
    return (1 - lx) * 0.52 + (1 - ty) * 0.48
}

/// Slightly more vertical weight (useful for hair hanging below the crown).
func shadeTTopLeftHair(px: Int, py: Int, width: Int, height: Int) -> CGFloat {
    let w = max(width, 1)
    let h = max(height, 1)
    let denomX = max(w - 1, 1)
    let denomY = max(h - 1, 1)
    let lx = CGFloat(px) / CGFloat(denomX)
    let ty = CGFloat(py) / CGFloat(denomY)
    return (1 - lx) * 0.38 + (1 - ty) * 0.62
}

func fillRectShadedSkin(
    _ context: CGContext,
    x: Int,
    y: Int,
    width: Int,
    height: Int,
    palette: CharacterShadingPalette
) {
    guard width > 0, height > 0 else { return }
    for py in 0..<height {
        for px in 0..<width {
            let t = shadeTTopLeft(px: px, py: py, width: width, height: height)
            fillPixel(context, x: x + px, y: y + py, color: palette.skin(at: t))
        }
    }
}

func fillRectShadedHair(
    _ context: CGContext,
    x: Int,
    y: Int,
    width: Int,
    height: Int,
    palette: CharacterShadingPalette
) {
    guard width > 0, height > 0 else { return }
    for py in 0..<height {
        for px in 0..<width {
            let t = shadeTTopLeftHair(px: px, py: py, width: width, height: height)
            fillPixel(context, x: x + px, y: y + py, color: palette.hair(at: t))
        }
    }
}

func clampProportion(_ v: CGFloat) -> CGFloat {
    min(max(v, 0.25), 1.75)
}
