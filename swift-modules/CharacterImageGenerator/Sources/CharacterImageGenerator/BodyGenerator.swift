//  Created by Alexander Skorulis on 4/4/2026.

import CoreGraphics

// MARK: - Body (torso + arms)

enum BodyGenerator {
    static func draw(context: CGContext, layout: CharacterLayout, palette: CharacterShadingPalette) {
        fillRectSkin(
            context,
            x: Int(layout.torsoX),
            y: Int(layout.torsoY),
            width: layout.torsoWi,
            height: layout.torsoHi,
            palette: palette
        )

        let armH = Int(ceil(layout.armLen))
        let shoulderY = Int(layout.shoulderY)
        drawArmWithHand(
            context: context,
            x: layout.leftArmX,
            shoulderY: shoulderY,
            armWidth: layout.armW,
            totalHeight: armH,
            unitScale: layout.unitScale,
            palette: palette,
            outerEdge: .left
        )
        drawArmWithHand(
            context: context,
            x: layout.rightArmX,
            shoulderY: shoulderY,
            armWidth: layout.armW,
            totalHeight: armH,
            unitScale: layout.unitScale,
            palette: palette,
            outerEdge: .right
        )
    }

    private enum ShoulderOuterEdge {
        case left
        case right
    }

    /// Upper arm plus a distinct hand block (reference: ~2×2 skin pixels on the base grid — here `2 * unitScale` tall, `armW` wide).
    /// The outer shoulder corner is chamfered row-by-row so the lateral outline is slightly curved, not a square corner.
    private static func drawArmWithHand(
        context: CGContext,
        x: Int,
        shoulderY: Int,
        armWidth: Int,
        totalHeight: Int,
        unitScale: CGFloat,
        palette: CharacterShadingPalette,
        outerEdge: ShoulderOuterEdge
    ) {
        guard totalHeight > 0, armWidth > 0 else { return }

        var chamfer = min(max(1, Int(round(unitScale / 2))), max(1, armWidth - 1))
        chamfer = min(chamfer, totalHeight)

        for dy in 0..<totalHeight {
            let y = shoulderY + dy
            let inset = dy < chamfer ? chamfer - dy : 0
            let w = armWidth - inset
            guard w > 0 else { continue }
            switch outerEdge {
            case .left:
                fillRectSkin(context, x: x + inset, y: y, width: w, height: 1, palette: palette)
            case .right:
                fillRectSkin(context, x: x, y: y, width: w, height: 1, palette: palette)
            }
        }
    }
}
