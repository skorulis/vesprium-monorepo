import CoreGraphics
import Foundation
import SnapshotTesting
import Testing
@testable import CharacterImageGenerator

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

private let tallLightMale = CharacterInfo(
    gender: .male,
    skinColor: RGB(r: 245, g: 220, b: 200),
    hairColor: RGB(r: 30, g: 25, b: 20),
    height: 1.5,
    weight: 0.85,
    armLength: 1.0,
    headSize: 0.9,
    legWear: .pants
)

private let shortHeavyFemale = CharacterInfo(
    gender: .female,
    skinColor: RGB(r: 120, g: 80, b: 60),
    hairColor: RGB(r: 200, g: 50, b: 40),
    height: 0.65,
    weight: 1.5,
    armLength: 0.8,
    headSize: 1.2,
    legWear: .pants
)

private let longArmsUnspecified = CharacterInfo(
    gender: .unspecified,
    skinColor: RGB(r: 200, g: 170, b: 140),
    hairColor: RGB(r: 50, g: 50, b: 55),
    height: 1.0,
    weight: 1.0,
    armLength: 1.5,
    headSize: 1.0,
    legWear: .pants
)

private let largeHeadFemale = CharacterInfo(
    gender: .female,
    skinColor: RGB(r: 255, g: 210, b: 180),
    hairColor: RGB(r: 15, g: 15, b: 20),
    height: 1.0,
    weight: 1.0,
    armLength: 1.0,
    headSize: 1.5,
    legWear: .pants
)

private let customEyeColor = CharacterInfo(
    gender: .male,
    skinColor: RGB(r: 245, g: 220, b: 200),
    hairColor: RGB(r: 30, g: 25, b: 20),
    eyeColor: RGB(r: 64, g: 120, b: 200),
    height: 1.0,
    weight: 1.0,
    armLength: 1.0,
    headSize: 1.0,
    legWear: .pants
)

private let mohawkMale = CharacterInfo(
    gender: .male,
    skinColor: RGB(r: 245, g: 220, b: 200),
    hairColor: RGB(r: 90, g: 40, b: 120),
    hairStyle: .mohawk,
    height: 1.0,
    weight: 1.0,
    armLength: 1.0,
    headSize: 1.0,
    legWear: .pants
)

private let baldFemale = CharacterInfo(
    gender: .female,
    skinColor: RGB(r: 200, g: 160, b: 130),
    hairColor: RGB(r: 40, g: 40, b: 45),
    hairStyle: .bald,
    height: 1.0,
    weight: 1.0,
    armLength: 1.0,
    headSize: 1.0,
    legWear: .pants
)

private let ponytailFemale = CharacterInfo(
    gender: .female,
    skinColor: RGB(r: 255, g: 210, b: 180),
    hairColor: RGB(r: 25, g: 20, b: 18),
    hairStyle: .ponytail,
    height: 1.0,
    weight: 1.0,
    armLength: 1.0,
    headSize: 1.0,
    legWear: .pants
)

private let bareLegsMale = CharacterInfo(
    gender: .male,
    skinColor: RGB(r: 245, g: 220, b: 200),
    hairColor: RGB(r: 30, g: 25, b: 20),
    height: 1.5,
    weight: 0.85,
    armLength: 1.0,
    headSize: 0.9,
    legWear: nil
)

private let tallShortsMale = CharacterInfo(
    gender: .male,
    skinColor: RGB(r: 245, g: 220, b: 200),
    hairColor: RGB(r: 30, g: 25, b: 20),
    height: 1.5,
    weight: 0.85,
    armLength: 1.0,
    headSize: 0.9,
    legWear: .shorts
)

/// Width used for snapshot PNGs (height is `2 * snapshotWidth`).
private let snapshotWidth = 48

private func nude(_ info: CharacterInfo) -> CharacterInfo {
    info.with(clothes: .nude())
}

/// Renders each character at ``snapshotWidth`` and composites them left-to-right into one bitmap.
private func compositeCGImagesHorizontally(_ images: [CGImage]) -> CGImage? {
    guard !images.isEmpty else { return nil }
    let w0 = images[0].width
    let h0 = images[0].height
    for img in images.dropFirst() {
        guard img.width == w0, img.height == h0 else { return nil }
    }
    let totalW = w0 * images.count
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bytesPerPixel = 4
    let bytesPerRow = totalW * bytesPerPixel
    var data = Data(count: totalW * h0 * bytesPerPixel)
    return data.withUnsafeMutableBytes { ptr -> CGImage? in
        memset(ptr.baseAddress!, 0, ptr.count)
        guard let context = CGContext(
            data: ptr.baseAddress,
            width: totalW,
            height: h0,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return nil }

        context.setShouldAntialias(false)
        context.interpolationQuality = .none
        for (i, img) in images.enumerated() {
            context.draw(
                img,
                in: CGRect(x: CGFloat(i * w0), y: 0, width: CGFloat(w0), height: CGFloat(h0))
            )
        }
        return context.makeImage()
    }
}

/// Snapshot assertion for several characters in one horizontal strip (fewer reference PNGs than one test per character).
private func assertSnapshotMatchesCharactersHorizontally(
    _ infos: [CharacterInfo],
    file: StaticString = #filePath,
    testName: String = #function,
    line: UInt = #line
) {
    let gen = CharacterImageGenerator()
    var images: [CGImage] = []
    for info in infos {
        guard let cgImage = gen.image(for: info, widthInPixels: snapshotWidth) else {
            Issue.record("Expected non-nil CGImage")
            return
        }
        images.append(cgImage)
    }
    guard let composite = compositeCGImagesHorizontally(images) else {
        Issue.record("Expected composite CGImage")
        return
    }
    #if canImport(AppKit)
    let image = NSImage(
        cgImage: composite,
        size: NSSize(width: composite.width, height: composite.height)
    )
    assertSnapshot(of: image, as: .image, file: file, testName: testName, line: line)
    #elseif canImport(UIKit)
    let image = UIImage(cgImage: composite, scale: 1.0, orientation: .up)
    assertSnapshot(of: image, as: .image, file: file, testName: testName, line: line)
    #endif
}

private func assertSnapshotMatchesCharacter(
    _ info: CharacterInfo,
    file: StaticString = #filePath,
    testName: String = #function,
    line: UInt = #line
) {
    let gen = CharacterImageGenerator()
    guard let cgImage = gen.image(for: info, widthInPixels: snapshotWidth) else {
        Issue.record("Expected non-nil CGImage")
        return
    }
    #if canImport(AppKit)
    let image = NSImage(
        cgImage: cgImage,
        size: NSSize(width: cgImage.width, height: cgImage.height)
    )
    assertSnapshot(of: image, as: .image, file: file, testName: testName, line: line)
    #elseif canImport(UIKit)
    let image = UIImage(cgImage: cgImage, scale: 1.0, orientation: .up)
    assertSnapshot(of: image, as: .image, file: file, testName: testName, line: line)
    #endif
}

@Test func initializes() async throws {
    _ = CharacterImageGenerator()
}

@Test func imageDimensionsMatchAspectRatio() async throws {
    let gen = CharacterImageGenerator()
    let width = 32
    guard let img = gen.image(for: tallLightMale, widthInPixels: width) else {
        Issue.record("Expected non-nil CGImage")
        return
    }
    #expect(img.width == width)
    #expect(img.height == width * 2)
}

@Test func pngDataIsNonEmpty() async throws {
    let gen = CharacterImageGenerator()
    let data = gen.pngData(for: shortHeavyFemale, widthInPixels: 24)
    #expect(data != nil)
    #expect(data!.count > 100)
    #expect(data!.starts(with: [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]))
}

@Test func tallLightMaleSnapshot() {
    assertSnapshotMatchesCharacter(tallLightMale)
}

@Test func shortHeavyFemaleSnapshot() {
    assertSnapshotMatchesCharacter(shortHeavyFemale)
}

@Test func longArmsUnspecifiedSnapshot() {
    assertSnapshotMatchesCharacter(longArmsUnspecified)
}

@Test func largeHeadFemaleSnapshot() {
    assertSnapshotMatchesCharacter(largeHeadFemale)
}

@Test func customEyeColorSnapshot() {
    assertSnapshotMatchesCharacter(customEyeColor)
}

@Test func mohawkMaleSnapshot() {
    assertSnapshotMatchesCharacter(mohawkMale)
}

@Test func baldFemaleSnapshot() {
    assertSnapshotMatchesCharacter(baldFemale)
}

@Test func ponytailFemaleSnapshot() {
    assertSnapshotMatchesCharacter(ponytailFemale)
}

@Test func tallShortsMaleSnapshot() {
    assertSnapshotMatchesCharacter(tallShortsMale)
}

/// Same proportions as ``tallShortsMale`` with ``LegWear/pants`` instead of shorts.
@Test func tallPantsMaleSnapshot() {
    assertSnapshotMatchesCharacter(tallLightMale)
}

@Test func bareLegsMaleSnapshot() {
    assertSnapshotMatchesCharacter(bareLegsMale)
}

/// Five nude (no leg wear) body types in one horizontal strip for easy comparison.
@Test func fiveNudeCharactersHorizontallySnapshot() {
    assertSnapshotMatchesCharactersHorizontally([
        nude(tallLightMale),
        nude(shortHeavyFemale),
        nude(longArmsUnspecified),
        nude(largeHeadFemale),
        nude(customEyeColor),
    ])
}
