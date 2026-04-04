//  Created by Alexander Skorulis on 4/4/2026.

import CoreGraphics

// MARK: - Legs + feet

enum LegsGenerator {
    static func draw(context: CGContext, layout: CharacterLayout, palette: CharacterShadingPalette) {
        fillRectSkin(
            context,
            x: layout.leftLegX,
            y: Int(layout.legY),
            width: layout.legWi,
            height: layout.legHi,
            palette: palette
        )
        fillRectSkin(
            context,
            x: layout.rightLegX,
            y: Int(layout.legY),
            width: layout.legWi,
            height: layout.legHi,
            palette: palette
        )

        let fy = Int(layout.legY) + layout.legHi
        let fh = layout.footH
        let pad = layout.footPad
        let h = layout.canvasHeight
        guard fy + fh <= h else { return }

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
