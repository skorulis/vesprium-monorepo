//  Created by Alexander Skorulis on 4/4/2026.

import CoreGraphics

// MARK: - Face (head + neck + hair + features)

enum FaceGenerator {
    static func drawHead(context: CGContext, layout: CharacterLayout, palette: CharacterShadingPalette) {
        drawHeadBase(context: context, layout: layout, palette: palette)
        drawNeck(context: context, layout: layout, palette: palette)
    }

    /// Head skin only (no neck). Used when something must be layered between head and neck (e.g. ponytail behind the torso).
    static func drawHeadBase(context: CGContext, layout: CharacterLayout, palette: CharacterShadingPalette) {
        fillPathSkin(context, path: headOutlinePath(layout: layout), palette: palette)
    }

    static func drawNeck(context: CGContext, layout: CharacterLayout, palette: CharacterShadingPalette) {
        fillRectSkin(
            context,
            x: Int(layout.neckX),
            y: Int(layout.neckY),
            width: layout.neckWi,
            height: layout.neckHi,
            palette: palette
        )
    }

    /// Drawn before neck, body, and legs so the torso and limbs occlude the tail (front view).
    static func drawPonytailTailBeforeBody(context: CGContext, layout: CharacterLayout, palette: CharacterShadingPalette) {
        let h = layout.canvasHeight
        let headYi = Int(layout.headY)
        let cx = Int(round(layout.centerX))
        let tailW = 2
        let tailX = cx - tailW / 2
        let headHi = Int(ceil(layout.headH))
        let startY = headYi + headHi
        let maxLen = min(max(4, Int(8 * layout.unitScale)), h - startY - 1)
        guard maxLen > 0 else { return }
        fillRectHair(
            context,
            x: tailX,
            y: startY,
            width: tailW,
            height: maxLen,
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
        let capRows = layout.hairCapRows

        switch layout.hairStyle {
        case .bald:
            break
        case .mohawk:
            let mw = max(2, headWi / 3)
            let mx = headXi + (headWi - mw) / 2
            let extraUp = max(1, Int(2 * layout.unitScale))
            // Rows above the skull sit outside `headOutlinePath`; draw without clipping.
            for up in 1...extraUp {
                let yy = headYi - up
                if yy >= 0 {
                    fillRectHair(
                        context,
                        x: mx,
                        y: yy,
                        width: mw,
                        height: 1,
                        palette: palette
                    )
                }
            }
            context.saveGState()
            context.addPath(headOutlinePath(layout: layout))
            context.clip()
            for i in 0..<capRows {
                let yy = headYi + i
                if yy < h {
                    fillRectHair(
                        context,
                        x: mx,
                        y: yy,
                        width: mw,
                        height: 1,
                        palette: palette
                    )
                }
            }
            context.restoreGState()
        case .buzz:
            context.saveGState()
            context.addPath(headOutlinePath(layout: layout))
            context.clip()
            drawHairCapBand(
                context: context,
                headXi: headXi,
                headYi: headYi,
                headWi: headWi,
                capRows: capRows,
                canvasHeight: h,
                palette: palette
            )
            context.restoreGState()
        case .short:
            context.saveGState()
            context.addPath(headOutlinePath(layout: layout))
            context.clip()
            drawHairCapBand(
                context: context,
                headXi: headXi,
                headYi: headYi,
                headWi: headWi,
                capRows: capRows,
                canvasHeight: h,
                palette: palette
            )
            drawSideHair(
                context: context,
                layout: layout,
                headXi: headXi,
                headYi: headYi,
                headWi: headWi,
                canvasHeight: h,
                palette: palette,
                bandScale: 4,
                includeNonFemale: false
            )
            context.restoreGState()
        case .long:
            context.saveGState()
            context.addPath(headOutlinePath(layout: layout))
            context.clip()
            drawHairCapBand(
                context: context,
                headXi: headXi,
                headYi: headYi,
                headWi: headWi,
                capRows: capRows,
                canvasHeight: h,
                palette: palette
            )
            drawSideHair(
                context: context,
                layout: layout,
                headXi: headXi,
                headYi: headYi,
                headWi: headWi,
                canvasHeight: h,
                palette: palette,
                bandScale: layout.gender == .female ? 6 : 3,
                includeNonFemale: true
            )
            context.restoreGState()
        case .ponytail:
            context.saveGState()
            context.addPath(headOutlinePath(layout: layout))
            context.clip()
            drawHairCapBand(
                context: context,
                headXi: headXi,
                headYi: headYi,
                headWi: headWi,
                capRows: capRows,
                canvasHeight: h,
                palette: palette
            )
            context.restoreGState()
        }
    }

    private static func drawHairCapBand(
        context: CGContext,
        headXi: Int,
        headYi: Int,
        headWi: Int,
        capRows: Int,
        canvasHeight: Int,
        palette: CharacterShadingPalette
    ) {
        for i in 0..<capRows {
            let yy = headYi + i
            if yy < canvasHeight {
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
    }

    private static func drawSideHair(
        context: CGContext,
        layout: CharacterLayout,
        headXi: Int,
        headYi: Int,
        headWi: Int,
        canvasHeight: Int,
        palette: CharacterShadingPalette,
        bandScale: Int,
        includeNonFemale: Bool
    ) {
        let useSides: Bool
        switch layout.gender {
        case .female:
            useSides = true
        case .male, .unspecified:
            useSides = includeNonFemale
        }
        guard useSides else { return }

        let sideHairH = min(bandScale * Int(max(1, layout.unitScale)), canvasHeight - Int(layout.headH) - 1)
        guard sideHairH > 0 else { return }
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
