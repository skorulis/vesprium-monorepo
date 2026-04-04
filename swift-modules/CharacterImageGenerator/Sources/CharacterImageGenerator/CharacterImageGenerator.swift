import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers

/// Builds front-facing pixel-art character images from ``CharacterInfo``.
public final class CharacterImageGenerator {
    public init() {}

    /// Logical canvas width in pixels (height is always `2 * logicalWidth`).
    private static let logicalWidth = 24
    private static let logicalHeight = 48

    /// Renders a character bitmap with width `widthInPixels` and height `2 * widthInPixels`.
    /// - Parameter widthInPixels: Output width; must be at least ``minimumOutputWidth``.
    public func image(for info: CharacterInfo, widthInPixels: Int) -> CGImage? {
        precondition(widthInPixels >= Self.minimumOutputWidth)
        guard let logical = makeLogicalImage(info: info) else { return nil }
        return scaleNearestNeighbor(
            logical,
            outputWidth: widthInPixels,
            outputHeight: widthInPixels * 2
        )
    }

    /// Encodes the image as PNG data, or `nil` if rendering fails.
    public func pngData(for info: CharacterInfo, widthInPixels: Int) -> Data? {
        guard let cgImage = image(for: info, widthInPixels: widthInPixels) else { return nil }
        let data = NSMutableData()
        guard let dest = CGImageDestinationCreateWithData(
            data as CFMutableData,
            UTType.png.identifier as CFString,
            1,
            nil
        ) else { return nil }
        CGImageDestinationAddImage(dest, cgImage, nil)
        guard CGImageDestinationFinalize(dest) else { return nil }
        return data as Data
    }

    public static let minimumOutputWidth = 8

    // MARK: - Logical raster (24×48)

    private func makeLogicalImage(info: CharacterInfo) -> CGImage? {
        let w = Self.logicalWidth
        let h = Self.logicalHeight
        let bytesPerPixel = 4
        let bytesPerRow = w * bytesPerPixel
        var data = Data(count: w * h * bytesPerPixel)
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        let skin = info.skinColor
        let hair = info.hairColor

        let heightP = Self.clampProportion(info.height)
        let weightP = Self.clampProportion(info.weight)
        let armP = Self.clampProportion(info.armLength)
        let headP = Self.clampProportion(info.headSize)

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
        headW = min(headW, CGFloat(w - 4))
        torsoW = min(torsoW, CGFloat(w - 2))

        let headX = floor(cx - headW / 2)
        let headYi = 0.0
        let torsoX = floor(cx - torsoW / 2)
        let torsoY = headH
        let torsoWi = Int(torsoW)
        let torsoHi = Int(ceil(torsoH))
        let armLen = min(8 * armP, CGFloat(h) - torsoY - 4)
        let armW = 2
        let shoulderY = torsoY + 2
        let leftArmX = Int(floor(cx - torsoW / 2 - CGFloat(armW)))
        // Must match the drawn torso width (`torsoWi` truncates `torsoW`); using `ceil(cx + torsoW/2)` leaves a gap.
        let rightArmX = Int(torsoX) + torsoWi
        let legGap: CGFloat = 2
        let legY = torsoY + CGFloat(torsoHi)
        let legWi = max(2, min(Int(ceil(legW)), Int(cx) - 2))
        let totalLegs = CGFloat(legWi * 2) + legGap
        let leftLegX = Int(floor(cx - totalLegs / 2))
        let rightLegX = leftLegX + legWi + Int(legGap)
        let legHi = Int(ceil(legH))
        let hairRows = max(2, Int(ceil(headH / 3)))

        return data.withUnsafeMutableBytes { ptr -> CGImage? in
            memset(ptr.baseAddress!, 0, ptr.count)
            guard let context = CGContext(
                data: ptr.baseAddress,
                width: w,
                height: h,
                bitsPerComponent: 8,
                bytesPerRow: bytesPerRow,
                space: colorSpace,
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            ) else { return nil }

            context.setShouldAntialias(false)
            context.interpolationQuality = .none

            // macOS bitmap contexts use a lower-left origin (Y up); layout code assumes top-left (Y down).
            #if os(macOS)
            context.translateBy(x: 0, y: CGFloat(h))
            context.scaleBy(x: 1, y: -1)
            #endif

            fillRect(context, x: Int(headX), y: Int(headYi), width: Int(headW), height: Int(ceil(headH)), color: skin)
            fillRect(context, x: Int(torsoX), y: Int(torsoY), width: torsoWi, height: torsoHi, color: skin)

            if info.gender == .female {
                let hipY = Int(torsoY) + torsoHi - 1
                let hipW = min(torsoWi + 4, w - 2)
                let hipX = Int(floor(cx - CGFloat(hipW) / 2))
                fillRect(context, x: hipX, y: hipY, width: hipW, height: 1, color: skin)
            }

            fillRect(
                context,
                x: leftArmX,
                y: Int(shoulderY),
                width: armW,
                height: Int(ceil(armLen)),
                color: skin
            )
            fillRect(
                context,
                x: rightArmX,
                y: Int(shoulderY),
                width: armW,
                height: Int(ceil(armLen)),
                color: skin
            )

            fillRect(context, x: leftLegX, y: Int(legY), width: legWi, height: legHi, color: skin)
            fillRect(context, x: rightLegX, y: Int(legY), width: legWi, height: legHi, color: skin)

            for i in 0..<hairRows {
                let yy = Int(headYi) + i
                if yy < h {
                    fillRect(context, x: Int(headX), y: yy, width: Int(headW), height: 1, color: hair)
                }
            }
            if info.gender == .female {
                let sideHairH = min(4, h - Int(headH) - 1)
                if sideHairH > 0 {
                    fillRect(context, x: Int(headX) - 1, y: Int(headYi) + 1, width: 1, height: sideHairH, color: hair)
                    fillRect(
                        context,
                        x: Int(ceil(headX + headW)),
                        y: Int(headYi) + 1,
                        width: 1,
                        height: sideHairH,
                        color: hair
                    )
                }
            }

            return context.makeImage()
        }
    }

    private func fillRect(
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

    private static func clampProportion(_ v: CGFloat) -> CGFloat {
        min(max(v, 0.25), 1.75)
    }

    private func scaleNearestNeighbor(
        _ source: CGImage,
        outputWidth: Int,
        outputHeight: Int
    ) -> CGImage? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = outputWidth * bytesPerPixel
        var data = Data(count: outputWidth * outputHeight * bytesPerPixel)
        return data.withUnsafeMutableBytes { ptr -> CGImage? in
            memset(ptr.baseAddress!, 0, ptr.count)
            guard let context = CGContext(
                data: ptr.baseAddress,
                width: outputWidth,
                height: outputHeight,
                bitsPerComponent: 8,
                bytesPerRow: bytesPerRow,
                space: colorSpace,
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            ) else { return nil }

            context.setShouldAntialias(false)
            context.interpolationQuality = .none
            context.draw(
                source,
                in: CGRect(x: 0, y: 0, width: outputWidth, height: outputHeight)
            )
            return context.makeImage()
        }
    }
}
