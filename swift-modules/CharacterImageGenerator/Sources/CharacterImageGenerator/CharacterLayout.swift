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
    let legWear: LegWear?
    let topWear: TopWear?

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
        skin = info.face.skinColor
        hair = info.face.hairColor
        gender = info.body.gender
        hairStyle = info.face.hairStyle
        legWear = info.clothes.legWear
        topWear = info.clothes.topWear

        let w = canvasWidth
        let h = canvasHeight
        let s = CGFloat(canvasWidth) / 24.0
        unitScale = s

        let heightP = clampProportion(info.body.height)
        let weightP = clampProportion(info.body.weight)
        let armP = clampProportion(info.body.armLength)
        let headP = clampProportion(info.face.headSize)

        var headW = 6 * headP * s
        var headH = 6 * headP * s
        var torsoW = 8 * weightP * s
        var torsoH = 10 * heightP * s
        let legW = 3 * weightP * s
        var legH = 12 * heightP * s

        switch info.body.gender {
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

        let legYBase = torsoYBase + CGFloat(torsoHi)
        // Leg outer edges align with torso sides; leg width is capped so both columns fit.
        let maxLegW = max(1, torsoWi / 2)
        let legWDesired = max(2, min(Int(ceil(legW)), Int(cx) - 2))
        legWi = min(legWDesired, maxLegW)
        let torsoLeft = Int(torsoX)
        leftLegX = torsoLeft
        rightLegX = torsoLeft + torsoWi - legWi
        legHi = Int(ceil(legH))
        hairRows = max(2, Int(ceil(headH / max(3 * s, 1))))
        switch info.face.hairStyle {
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

    /// Rows of each leg covered by shorts when ``legWear`` is ``LegWear/shorts``; `0` if bare legs or pants.
    var shortsLegCoveragePixels: Int {
        guard case .some(.shorts) = legWear else { return 0 }
        return min(legHi, max(2, legHi * 2 / 5))
    }

    /// Height of the inner-leg (inseam) fabric that joins the two legs—only at the top of the garment, not full leg length.
    var innerLegCrotchFillHeight: Int {
        let cap = max(2, Int(round(2 * unitScale)))
        return min(legHi, cap)
    }

    /// Rows of each upper arm (from the shoulder, excluding the hand block) covered by ``topWear``; `0` if bare torso or no top.
    func sleeveRowsOnUpperArm(upperArmHeight: Int) -> Int {
        guard let tw = topWear, upperArmHeight > 0 else { return 0 }
        switch tw {
        case .tShirt:
            return min(upperArmHeight, max(2, upperArmHeight * 2 / 5))
        case .shirt:
            return upperArmHeight
        case .singlet:
            return 0
        }
    }
}
