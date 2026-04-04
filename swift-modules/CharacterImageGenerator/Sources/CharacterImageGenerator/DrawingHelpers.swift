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

func clampProportion(_ v: CGFloat) -> CGFloat {
    min(max(v, 0.25), 1.75)
}
