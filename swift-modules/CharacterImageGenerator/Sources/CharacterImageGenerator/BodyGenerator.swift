//  Created by Alexander Skorulis on 4/4/2026.

import CoreGraphics

// MARK: - Body (torso + arms)

enum BodyGenerator {
    static func draw(context: CGContext, layout: CharacterLayout, palette: CharacterShadingPalette) {
        fillRectShadedSkin(
            context,
            x: Int(layout.torsoX),
            y: Int(layout.torsoY),
            width: layout.torsoWi,
            height: layout.torsoHi,
            palette: palette
        )

        if layout.gender == .female {
            let w = layout.canvasWidth
            let hipY = Int(layout.torsoY) + layout.torsoHi - 1
            let hipW = min(layout.torsoWi + 4, w - 2)
            let hipX = Int(floor(layout.centerX - CGFloat(hipW) / 2))
            let hip = palette.skin[min(3, palette.skin.count - 1)]
            fillRect(context, x: hipX, y: hipY, width: hipW, height: 1, color: hip)
        }

        let armH = Int(ceil(layout.armLen))
        let shoulderY = Int(layout.shoulderY)
        drawArmWithHand(
            context: context,
            x: layout.leftArmX,
            shoulderY: shoulderY,
            armWidth: layout.armW,
            totalHeight: armH,
            unitScale: layout.unitScale,
            palette: palette
        )
        drawArmWithHand(
            context: context,
            x: layout.rightArmX,
            shoulderY: shoulderY,
            armWidth: layout.armW,
            totalHeight: armH,
            unitScale: layout.unitScale,
            palette: palette
        )
    }

    /// Upper arm plus a distinct hand block (reference: ~2×2 skin pixels on the base grid — here `2 * unitScale` tall, `armW` wide).
    private static func drawArmWithHand(
        context: CGContext,
        x: Int,
        shoulderY: Int,
        armWidth: Int,
        totalHeight: Int,
        unitScale: CGFloat,
        palette: CharacterShadingPalette
    ) {
        guard totalHeight > 0 else { return }
        let desiredHandH = max(2, Int(round(2 * unitScale)))
        let handH = min(desiredHandH, totalHeight)
        let upperH = totalHeight - handH
        if upperH > 0 {
            fillRectShadedSkin(
                context,
                x: x,
                y: shoulderY,
                width: armWidth,
                height: upperH,
                palette: palette
            )
        }
        fillRectShadedSkin(
            context,
            x: x,
            y: shoulderY + upperH,
            width: armWidth,
            height: handH,
            palette: palette
        )
    }
}
