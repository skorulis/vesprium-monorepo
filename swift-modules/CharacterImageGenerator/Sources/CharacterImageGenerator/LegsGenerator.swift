//  Created by Alexander Skorulis on 4/4/2026.

import CoreGraphics

// MARK: - Legs + feet

enum LegsGenerator {
    static func draw(context: CGContext, layout: CharacterLayout, palette: CharacterShadingPalette) {
        let y = Int(layout.legY)
        let w = layout.legWi
        let legH = layout.legHi
        switch layout.legWear {
        case .pants:
            fillRect(context, x: layout.leftLegX, y: y, width: w, height: legH, color: palette.pantsFlat)
            fillRect(context, x: layout.rightLegX, y: y, width: w, height: legH, color: palette.pantsFlat)
            fillInnerLegGap(
                context,
                layout: layout,
                topY: y,
                height: layout.innerLegCrotchFillHeight,
                color: palette.pantsFlat
            )
        case .shorts:
            let sh = layout.shortsLegCoveragePixels
            fillRect(context, x: layout.leftLegX, y: y, width: w, height: sh, color: palette.shortsFlat)
            fillRectSkin(
                context,
                x: layout.leftLegX,
                y: y + sh,
                width: w,
                height: legH - sh,
                palette: palette
            )
            fillRect(context, x: layout.rightLegX, y: y, width: w, height: sh, color: palette.shortsFlat)
            fillRectSkin(
                context,
                x: layout.rightLegX,
                y: y + sh,
                width: w,
                height: legH - sh,
                palette: palette
            )
            let crotchH = min(sh, layout.innerLegCrotchFillHeight)
            fillInnerLegGap(context, layout: layout, topY: y, height: crotchH, color: palette.shortsFlat)
        }

        let fy = Int(layout.legY) + layout.legHi
        let fh = layout.footH
        let pad = layout.footPad
        let canvasH = layout.canvasHeight
        guard fy + fh <= canvasH else { return }

        fillLeftFootShaded(
            context,
            legX: layout.leftLegX,
            legW: layout.legWi,
            y: fy,
            height: fh,
            outwardPad: pad,
            palette: palette
        )
        fillRightFootShaded(
            context,
            legX: layout.rightLegX,
            legW: layout.legWi,
            y: fy,
            height: fh,
            outwardPad: pad,
            palette: palette
        )
    }

    /// Fabric between the leg columns at the top only (crotch / upper inseam), not the full garment height.
    private static func fillInnerLegGap(
        _ context: CGContext,
        layout: CharacterLayout,
        topY: Int,
        height: Int,
        color: RGB
    ) {
        guard height > 0 else { return }
        let gapStart = layout.leftLegX + layout.legWi
        let gapEnd = layout.rightLegX - 1
        guard gapEnd >= gapStart else { return }
        fillRect(
            context,
            x: gapStart,
            y: topY,
            width: gapEnd - gapStart + 1,
            height: height,
            color: color
        )
    }

    /// Ankle column matches the leg width; toes extend only to the left (away from the body midline).
    private static func fillLeftFootShaded(
        _ context: CGContext,
        legX: Int,
        legW: Int,
        y: Int,
        height: Int,
        outwardPad: Int,
        palette: CharacterShadingPalette
    ) {
        guard height > 0, legW > 0, outwardPad > 0 else { return }
        let minX = legX - outwardPad
        let maxX = legX + legW - 1
        let bboxW = maxX - minX + 1
        for py in 0..<height {
            for lx in 0..<bboxW {
                let x = minX + lx
                let inAnkle = x >= legX && x < legX + legW
                let inToe = x >= legX - outwardPad && x < legX
                guard inAnkle || inToe else { continue }
                fillPixel(context, x: x, y: y + py, color: palette.skinFlat)
            }
        }
    }

    /// Ankle column matches the leg width; toes extend only to the right (away from the body midline).
    private static func fillRightFootShaded(
        _ context: CGContext,
        legX: Int,
        legW: Int,
        y: Int,
        height: Int,
        outwardPad: Int,
        palette: CharacterShadingPalette
    ) {
        guard height > 0, legW > 0, outwardPad > 0 else { return }
        let minX = legX
        let maxX = legX + legW + outwardPad - 1
        let bboxW = maxX - minX + 1
        for py in 0..<height {
            for lx in 0..<bboxW {
                let x = minX + lx
                let inAnkle = x >= legX && x < legX + legW
                let inToe = x >= legX + legW && x < legX + legW + outwardPad
                guard inAnkle || inToe else { continue }
                fillPixel(context, x: x, y: y + py, color: palette.skinFlat)
            }
        }
    }
}
