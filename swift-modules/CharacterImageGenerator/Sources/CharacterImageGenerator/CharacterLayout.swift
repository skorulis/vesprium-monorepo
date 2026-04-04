//  Created by Alexander Skorulis on 4/4/2026.

import CoreGraphics

/// Pixel positions and sizes for one logical character render.
struct CharacterLayout {
    let canvasWidth: Int
    let canvasHeight: Int

    let skin: RGB
    let hair: RGB
    let gender: Gender

    let headX: CGFloat
    let headY: CGFloat
    let headW: CGFloat
    let headH: CGFloat

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

    let hairRows: Int

    let centerX: CGFloat

    init(info: CharacterInfo, canvasWidth: Int, canvasHeight: Int) {
        self.canvasWidth = canvasWidth
        self.canvasHeight = canvasHeight
        skin = info.skinColor
        hair = info.hairColor
        gender = info.gender

        let w = canvasWidth
        let h = canvasHeight

        let heightP = clampProportion(info.height)
        let weightP = clampProportion(info.weight)
        let armP = clampProportion(info.armLength)
        let headP = clampProportion(info.headSize)

        var headW = 6 * headP
        var headH = 6 * headP
        var torsoW = 8 * weightP
        var torsoH = 10 * heightP
        let legW = 3 * weightP
        var legH = 12 * heightP

        switch info.gender {
        case .male:
            torsoW += 1
        case .female:
            torsoW += 0.5
        case .unspecified:
            break
        }

        let totalH = headH + torsoH + legH
        let maxContentH = CGFloat(h - 2)
        if totalH > maxContentH {
            let s = maxContentH / totalH
            headH *= s
            torsoH *= s
            legH *= s
        }

        let cx = CGFloat(w) / 2
        centerX = cx
        headW = min(headW, CGFloat(w - 4))
        torsoW = min(torsoW, CGFloat(w - 2))

        headX = floor(cx - headW / 2)
        headY = 0
        torsoX = floor(cx - torsoW / 2)
        torsoY = headH
        torsoWi = Int(torsoW)
        torsoHi = Int(ceil(torsoH))
        armLen = min(8 * armP, CGFloat(h) - torsoY - 4)
        armW = 2
        shoulderY = torsoY + 2
        leftArmX = Int(floor(cx - torsoW / 2 - CGFloat(armW)))
        // Must match the drawn torso width (`torsoWi` truncates `torsoW`); using `ceil(cx + torsoW/2)` leaves a gap.
        rightArmX = Int(torsoX) + torsoWi

        let legGap: CGFloat = 2
        legY = torsoY + CGFloat(torsoHi)
        legWi = max(2, min(Int(ceil(legW)), Int(cx) - 2))
        let totalLegs = CGFloat(legWi * 2) + legGap
        leftLegX = Int(floor(cx - totalLegs / 2))
        rightLegX = leftLegX + legWi + Int(legGap)
        legHi = Int(ceil(legH))
        hairRows = max(2, Int(ceil(headH / 3)))

        self.headW = headW
        self.headH = headH
    }
}
