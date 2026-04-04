//  Created by Alexander Skorulis on 4/4/2026.

import CoreGraphics

// MARK: - Legs

enum LegsGenerator {
    static func draw(context: CGContext, layout: CharacterLayout) {
        fillRect(
            context,
            x: layout.leftLegX,
            y: Int(layout.legY),
            width: layout.legWi,
            height: layout.legHi,
            color: layout.skin
        )
        fillRect(
            context,
            x: layout.rightLegX,
            y: Int(layout.legY),
            width: layout.legWi,
            height: layout.legHi,
            color: layout.skin
        )
    }
}
