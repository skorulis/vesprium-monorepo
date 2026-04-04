//  Created by Alexander Skorulis on 4/4/2026.

import CoreGraphics

/// Pixel positions and sizes for one logical character render.
struct CharacterLayout {
    let canvasWidth: Int
    let canvasHeight: Int

    let skin: RGB
    let hair: RGB
    let gender: Gender
    let hairStyle: HairStyle

    /// Uniform scale vs the original 24× logical grid (e.g. `2` when width is 48).
    let unitScale: CGFloat

    let headX: CGFloat
    let headY: CGFloat
    let headW: CGFloat
    let headH: CGFloat

    let neckX: CGFloat
    let neckY: CGFloat
    let neckWi: Int
    let neckHi: Int

    let torsoX: CGFloat
    let torsoY: CGFloat
    let torsoWi: Int
    let torsoHi: Int

    let armLen: CGFloat
    let armW: Int
    let shoulderY: CGFloat
    let leftArmX: Int
    let rightArmX: Int

    let legY: CGFloat
    let legWi: Int
    let legHi: Int
    let leftLegX: Int
    let rightLegX: Int

    let footH: Int
    let footPad: Int

    let hairRows: Int
    /// Rows of hair drawn on the skull (forehead seam); `0` when bald.
    let hairCapRows: Int

    let centerX: CGFloat

    init(info: CharacterInfo, canvasWidth: Int, canvasHeight: Int) {
        self.canvasWidth = canvasWidth
        self.canvasHeight = canvasHeight
        skin = info.skinColor
        hair = info.hairColor
        gender = info.gender
        hairStyle = info.hairStyle

        let w = canvasWidth
        let h = canvasHeight
        let s = CGFloat(canvasWidth) / 24.0
        unitScale = s

        let heightP = clampProportion(info.height)
        let weightP = clampProportion(info.weight)
        let armP = clampProportion(info.armLength)
        let headP = clampProportion(info.headSize)

        var headW = 6 * headP * s
        var headH = 6 * headP * s
        var torsoW = 8 * weightP * s
        var torsoH = 10 * heightP * s
        let legW = 3 * weightP * s
        var legH = 12 * heightP * s

        switch info.gender {
        case .male:
            torsoW += 1 * s
        case .female:
            torsoW += 0.5 * s
        case .unspecified:
            break
        }

        var neckH = max(1 * s, 1)
        let footHForBounds = CGFloat(max(1, Int(round(1 * s))))
        let maxContentH = CGFloat(h - 2)
        let totalH = headH + neckH + torsoH + legH + footHForBounds
        if totalH > maxContentH {
            let shrink = maxContentH / totalH
            headH *= shrink
            neckH *= shrink
            torsoH *= shrink
            legH *= shrink
        }

        let cx = CGFloat(w) / 2
        centerX = cx
        headW = min(headW, CGFloat(w - 4))
        torsoW = min(torsoW, CGFloat(w - 2))

        headX = floor(cx - headW / 2)

        neckWi = max(2, Int(round(2 * s)))
        neckHi = max(1, Int(round(neckH)))
        neckX = floor(cx - CGFloat(neckWi) / 2)

        torsoX = floor(cx - torsoW / 2)
        torsoWi = Int(torsoW)
        torsoHi = Int(ceil(torsoH))

        let torsoYBase = headH + CGFloat(neckHi)
        armLen = min(8 * armP * s, CGFloat(h) - torsoYBase - 2 * s)
        armW = max(2, Int(round(2 * s)))
        let shoulderYBase = torsoYBase
        leftArmX = Int(floor(cx - torsoW / 2 - CGFloat(armW)))
        rightArmX = Int(torsoX) + torsoWi

        let legGap = 2 * s
        let legYBase = torsoYBase + CGFloat(torsoHi)
        legWi = max(2, min(Int(ceil(legW)), Int(cx) - 2))
        let totalLegs = CGFloat(legWi * 2) + legGap
        leftLegX = Int(floor(cx - totalLegs / 2))
        rightLegX = leftLegX + legWi + Int(legGap)
        legHi = Int(ceil(legH))
        hairRows = max(2, Int(ceil(headH / max(3 * s, 1))))
        switch info.hairStyle {
        case .bald:
            hairCapRows = 0
        case .buzz:
            hairCapRows = max(1, min(2, hairRows / 2))
        case .short, .long, .ponytail, .mohawk:
            hairCapRows = hairRows
        }

        footH = max(1, Int(round(1 * s)))
        footPad = max(1, Int(round(1 * s)))

        self.headW = headW
        self.headH = headH

        let bottomExclusive = legYBase + CGFloat(legHi) + CGFloat(footH)
        let verticalOffset = CGFloat(h) - bottomExclusive

        headY = verticalOffset
        neckY = headH + verticalOffset
        torsoY = torsoYBase + verticalOffset
        shoulderY = shoulderYBase + verticalOffset
        legY = legYBase + verticalOffset
    }
}
