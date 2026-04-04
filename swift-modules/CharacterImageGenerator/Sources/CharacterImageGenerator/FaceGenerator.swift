//  Created by Alexander Skorulis on 4/4/2026.

import CoreGraphics

// MARK: - Face (head + hair)

enum FaceGenerator {
    static func drawHead(context: CGContext, layout: CharacterLayout) {
        fillRect(
            context,
            x: Int(layout.headX),
            y: Int(layout.headY),
            width: Int(layout.headW),
            height: Int(ceil(layout.headH)),
            color: layout.skin
        )
    }

    static func drawHair(context: CGContext, layout: CharacterLayout) {
        let h = layout.canvasHeight
        let headYi = Int(layout.headY)
        for i in 0..<layout.hairRows {
            let yy = headYi + i
            if yy < h {
                fillRect(
                    context,
                    x: Int(layout.headX),
                    y: yy,
                    width: Int(layout.headW),
                    height: 1,
                    color: layout.hair
                )
            }
        }
        if layout.gender == .female {
            let sideHairH = min(4, h - Int(layout.headH) - 1)
            if sideHairH > 0 {
                fillRect(context, x: Int(layout.headX) - 1, y: headYi + 1, width: 1, height: sideHairH, color: layout.hair)
                fillRect(
                    context,
                    x: Int(ceil(layout.headX + layout.headW)),
                    y: headYi + 1,
                    width: 1,
                    height: sideHairH,
                    color: layout.hair
                )
            }
        }
    }
}
