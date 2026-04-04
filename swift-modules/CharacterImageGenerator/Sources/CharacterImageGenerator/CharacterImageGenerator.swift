import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers

/// Builds front-facing pixel-art character images from ``CharacterInfo``.
public final class CharacterImageGenerator {
    public init() {}

    /// Logical canvas width in pixels (height is always `2 * logicalWidth`).
    /// Larger than the original 24× grid so shading and facial features have room to read.
    private static let logicalWidth = 48
    private static let logicalHeight = 96

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

    // MARK: - Logical raster (48×96)

    private func makeLogicalImage(info: CharacterInfo) -> CGImage? {
        let w = Self.logicalWidth
        let h = Self.logicalHeight
        let bytesPerPixel = 4
        let bytesPerRow = w * bytesPerPixel
        var data = Data(count: w * h * bytesPerPixel)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let layout = CharacterLayout(info: info, canvasWidth: w, canvasHeight: h)
        let palette = CharacterShadingPalette(skinBase: info.skinColor, hairBase: info.hairColor)

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

            FaceGenerator.drawHead(context: context, layout: layout, palette: palette)
            BodyGenerator.draw(context: context, layout: layout, palette: palette)
            LegsGenerator.draw(context: context, layout: layout, palette: palette)
            FaceGenerator.drawHair(context: context, layout: layout, palette: palette)
            FaceGenerator.drawFaceFeatures(context: context, layout: layout, palette: palette)

            return context.makeImage()
        }
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
