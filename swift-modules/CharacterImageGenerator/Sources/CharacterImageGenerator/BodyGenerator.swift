//  Created by Alexander Skorulis on 4/4/2026.

import CoreGraphics

// MARK: - Body (torso + arms)

enum BodyGenerator {
    static func draw(context: CGContext, layout: CharacterLayout) {
        fillRect(
            context,
            x: Int(layout.torsoX),
            y: Int(layout.torsoY),
            width: layout.torsoWi,
            height: layout.torsoHi,
            color: layout.skin
        )

        if layout.gender == .female {
            let w = layout.canvasWidth
            let hipY = Int(layout.torsoY) + layout.torsoHi - 1
            let hipW = min(layout.torsoWi + 4, w - 2)
            let hipX = Int(floor(layout.centerX - CGFloat(hipW) / 2))
            fillRect(context, x: hipX, y: hipY, width: hipW, height: 1, color: layout.skin)
        }

        fillRect(
            context,
            x: layout.leftArmX,
            y: Int(layout.shoulderY),
            width: layout.armW,
            height: Int(ceil(layout.armLen)),
            color: layout.skin
        )
        fillRect(
            context,
            x: layout.rightArmX,
            y: Int(layout.shoulderY),
            width: layout.armW,
            height: Int(ceil(layout.armLen)),
            color: layout.skin
        )
    }
}
