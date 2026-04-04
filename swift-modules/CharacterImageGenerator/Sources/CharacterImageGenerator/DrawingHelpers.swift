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

func fillRectSkin(
    _ context: CGContext,
    x: Int,
    y: Int,
    width: Int,
    height: Int,
    palette: CharacterShadingPalette
) {
    fillRect(context, x: x, y: y, width: width, height: height, color: palette.skinFlat)
}

func fillRectHair(
    _ context: CGContext,
    x: Int,
    y: Int,
    width: Int,
    height: Int,
    palette: CharacterShadingPalette
) {
    fillRect(context, x: x, y: y, width: width, height: height, color: palette.hairFlat)
}

func strokeHLine(
    _ context: CGContext,
    x0: Int,
    x1: Int,
    y: Int,
    color: RGB
) {
    guard x1 >= x0 else { return }
    fillRect(context, x: x0, y: y, width: x1 - x0 + 1, height: 1, color: color)
}

func strokeVLine(
    _ context: CGContext,
    x: Int,
    y0: Int,
    y1: Int,
    color: RGB
) {
    guard y1 >= y0 else { return }
    fillRect(context, x: x, y: y0, width: 1, height: y1 - y0 + 1, color: color)
}

/// 1px seams between head, neck, torso, limbs, hair cap, and feet (drawn after solid regions).
func drawCharacterElementDivisions(context: CGContext, layout: CharacterLayout, palette: CharacterShadingPalette) {
    let neckXi = Int(layout.neckX)
    let torsoYi = Int(layout.torsoY)
    let torsoX = Int(layout.torsoX)
    let shoulderYi = Int(layout.shoulderY)
    let armH = Int(ceil(layout.armLen))
    let desiredHandH = max(2, Int(round(2 * layout.unitScale)))
    let handH = min(desiredHandH, armH)
    let upperH = armH - handH

    strokeHLine(
        context,
        x0: neckXi,
        x1: neckXi + layout.neckWi - 1,
        y: Int(layout.neckY),
        color: palette.skinDivision
    )
    strokeHLine(
        context,
        x0: torsoX,
        x1: torsoX + layout.torsoWi - 1,
        y: torsoYi,
        color: palette.skinDivision
    )
    strokeHLine(
        context,
        x0: torsoX,
        x1: torsoX + layout.torsoWi - 1,
        y: Int(layout.legY),
        color: palette.skinDivision
    )

    strokeVLine(
        context,
        x: torsoX,
        y0: shoulderYi,
        y1: shoulderYi + armH - 1,
        color: palette.skinDivision
    )
    strokeVLine(
        context,
        x: torsoX + layout.torsoWi - 1,
        y0: shoulderYi,
        y1: shoulderYi + armH - 1,
        color: palette.skinDivision
    )

    if upperH > 0 {
        let yHand = shoulderYi + upperH
        strokeHLine(
            context,
            x0: layout.leftArmX,
            x1: layout.leftArmX + layout.armW - 1,
            y: yHand,
            color: palette.skinDivision
        )
        strokeHLine(
            context,
            x0: layout.rightArmX,
            x1: layout.rightArmX + layout.armW - 1,
            y: yHand,
            color: palette.skinDivision
        )
    }

    let footTop = Int(layout.legY) + layout.legHi
    strokeHLine(
        context,
        x0: layout.leftLegX,
        x1: layout.leftLegX + layout.legWi - 1,
        y: footTop,
        color: palette.skinDivision
    )
    strokeHLine(
        context,
        x0: layout.rightLegX,
        x1: layout.rightLegX + layout.legWi - 1,
        y: footTop,
        color: palette.skinDivision
    )

    let headYi = Int(layout.headY)
    let headXi = Int(layout.headX)
    let headWi = max(1, Int(ceil(layout.headW)))
    if layout.hairCapRows > 0 {
        let hairBottomY = headYi + layout.hairCapRows - 1
        switch layout.hairStyle {
        case .mohawk:
            let mw = max(2, headWi / 3)
            let mx = headXi + (headWi - mw) / 2
            strokeHLine(
                context,
                x0: mx,
                x1: mx + mw - 1,
                y: hairBottomY,
                color: palette.hairDivision
            )
        case .short, .buzz, .long, .ponytail:
            strokeHLine(
                context,
                x0: headXi,
                x1: headXi + headWi - 1,
                y: hairBottomY,
                color: palette.hairDivision
            )
        case .bald:
            break
        }
    }
}

func clampProportion(_ v: CGFloat) -> CGFloat {
    min(max(v, 0.5), 1.5)
}
