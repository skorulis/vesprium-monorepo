//  Created by Alexander Skorulis on 4/4/2026.

import CoreGraphics

// MARK: - Face (head + neck + hair + features)

enum FaceGenerator {
    static func drawHead(context: CGContext, layout: CharacterLayout, palette: CharacterShadingPalette) {
        fillRectSkin(
            context,
            x: Int(layout.headX),
            y: Int(layout.headY),
            width: Int(ceil(layout.headW)),
            height: Int(ceil(layout.headH)),
            palette: palette
        )
        fillRectSkin(
            context,
            x: Int(layout.neckX),
            y: Int(layout.neckY),
            width: layout.neckWi,
            height: layout.neckHi,
            palette: palette
        )
    }

    static func drawFaceFeatures(context: CGContext, layout: CharacterLayout, palette: CharacterShadingPalette) {
        let hy = Int(layout.headY)
        let hw = max(1, Int(ceil(layout.headW)))
        let hh = max(1, Int(ceil(layout.headH)))
        let cx = Int(layout.centerX)

        let eyeY = hy + max(1, (hh * 2) / 5)
        let spread = max(1, hw / 5)
        drawEye(context, centerX: cx - spread, y: eyeY, palette: palette, opensToTheRight: true)
        drawEye(context, centerX: cx + spread, y: eyeY, palette: palette, opensToTheRight: false)

        let mouthW = min(3, max(2, hw / 4))
        let mouthY = hy + hh - max(2, hh / 5)
        let mx = cx - mouthW / 2
        for dx in 0..<mouthW {
            fillPixel(context, x: mx + dx, y: mouthY, color: palette.mouth)
        }
    }

    /// One iris pixel plus darker pixels on the outer side and eyelid lines (avoids overlap at the nose bridge).
    private static func drawEye(
        _ context: CGContext,
        centerX: Int,
        y: Int,
        palette: CharacterShadingPalette,
        opensToTheRight: Bool
    ) {
        fillPixel(context, x: centerX, y: y, color: palette.eye)
        let outwardDx = opensToTheRight ? -1 : 1
        fillPixel(context, x: centerX + outwardDx, y: y, color: palette.eyeShade)
        fillPixel(context, x: centerX, y: y - 1, color: palette.eyeShade)
        fillPixel(context, x: centerX, y: y + 1, color: palette.eyeShade)
        fillPixel(context, x: centerX + outwardDx, y: y - 1, color: palette.eyeShade)
        fillPixel(context, x: centerX + outwardDx, y: y + 1, color: palette.eyeShade)
    }

    static func drawHair(context: CGContext, layout: CharacterLayout, palette: CharacterShadingPalette) {
        let h = layout.canvasHeight
        let headYi = Int(layout.headY)
        let headWi = Int(ceil(layout.headW))
        let headXi = Int(layout.headX)

        for i in 0..<layout.hairRows {
            let yy = headYi + i
            if yy < h {
                fillRectHair(
                    context,
                    x: headXi,
                    y: yy,
                    width: headWi,
                    height: 1,
                    palette: palette
                )
            }
        }

        if layout.gender == .female {
            let sideHairH = min(4 * Int(max(1, layout.unitScale)), h - Int(layout.headH) - 1)
            if sideHairH > 0 {
                fillRectHair(
                    context,
                    x: headXi - 1,
                    y: headYi + 1,
                    width: 1,
                    height: sideHairH,
                    palette: palette
                )
                fillRectHair(
                    context,
                    x: headXi + headWi,
                    y: headYi + 1,
                    width: 1,
                    height: sideHairH,
                    palette: palette
                )
            }
        }
    }
}
