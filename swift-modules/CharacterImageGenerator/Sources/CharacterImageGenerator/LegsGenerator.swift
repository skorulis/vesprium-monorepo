//  Created by Alexander Skorulis on 4/4/2026.

import CoreGraphics

// MARK: - Legs + feet

enum LegsGenerator {
    static func draw(context: CGContext, layout: CharacterLayout, palette: CharacterShadingPalette) {
        fillRectShadedSkin(
            context,
            x: layout.leftLegX,
            y: Int(layout.legY),
            width: layout.legWi,
            height: layout.legHi,
            palette: palette
        )
        fillRectShadedSkin(
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

        let leftFx = layout.leftLegX - pad
        let rightFx = layout.rightLegX - pad
        let footW = layout.legWi + 2 * pad

        fillRectShadedSkin(context, x: leftFx, y: fy, width: footW, height: fh, palette: palette)
        fillRectShadedSkin(context, x: rightFx, y: fy, width: footW, height: fh, palette: palette)
    }
}
