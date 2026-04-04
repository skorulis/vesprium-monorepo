import CoreGraphics
import Foundation
import Testing
@testable import CharacterImageGenerator

private let tallLightMale = CharacterInfo(
    gender: .male,
    skinColor: RGB(r: 245, g: 220, b: 200),
    hairColor: RGB(r: 30, g: 25, b: 20),
    height: 1.5,
    weight: 0.85,
    armLength: 1.0,
    headSize: 0.9
)

private let shortHeavyFemale = CharacterInfo(
    gender: .female,
    skinColor: RGB(r: 120, g: 80, b: 60),
    hairColor: RGB(r: 200, g: 50, b: 40),
    height: 0.65,
    weight: 1.65,
    armLength: 0.8,
    headSize: 1.2
)

private let longArmsUnspecified = CharacterInfo(
    gender: .unspecified,
    skinColor: RGB(r: 200, g: 170, b: 140),
    hairColor: RGB(r: 50, g: 50, b: 55),
    height: 1.0,
    weight: 1.0,
    armLength: 1.75,
    headSize: 1.0
)

private let largeHeadFemale = CharacterInfo(
    gender: .female,
    skinColor: RGB(r: 255, g: 210, b: 180),
    hairColor: RGB(r: 15, g: 15, b: 20),
    height: 1.0,
    weight: 1.0,
    armLength: 1.0,
    headSize: 1.65
)

private func checksumRGBA32(_ image: CGImage) -> UInt64 {
    let w = image.width
    let h = image.height
    let bytesPerPixel = 4
    let bytesPerRow = w * bytesPerPixel
    var data = Data(count: w * h * bytesPerPixel)
    guard let colorSpace = image.colorSpace else { return 0 }
    data.withUnsafeMutableBytes { ptr in
        guard let ctx = CGContext(
            data: ptr.baseAddress,
            width: w,
            height: h,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return }
        ctx.draw(image, in: CGRect(x: 0, y: 0, width: w, height: h))
    }
    var hash: UInt64 = 5381
    for byte in data {
        hash = ((hash &<< 5) &+ hash) &+ UInt64(byte)
    }
    return hash
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

@Test func examplePresetsProduceStableChecksums() async throws {
    let gen = CharacterImageGenerator()
    let width = 48

    guard let a = gen.image(for: tallLightMale, widthInPixels: width),
          let b = gen.image(for: shortHeavyFemale, widthInPixels: width),
          let c = gen.image(for: longArmsUnspecified, widthInPixels: width),
          let d = gen.image(for: largeHeadFemale, widthInPixels: width)
    else {
        Issue.record("Expected all images")
        return
    }

    let ha = checksumRGBA32(a)
    let hb = checksumRGBA32(b)
    let hc = checksumRGBA32(c)
    let hd = checksumRGBA32(d)

    #expect(ha != 0)
    #expect(hb != 0)
    #expect(hc != 0)
    #expect(hd != 0)

    #expect(ha != hb)
    #expect(ha != hc)
    #expect(hb != hd)

    // Regression anchors (UInt64; update if pixel output intentionally changes)
    #expect(ha == ANCHOR_TALL_LIGHT_MALE)
    #expect(hb == ANCHOR_SHORT_HEAVY_FEMALE)
    #expect(hc == ANCHOR_LONG_ARMS)
    #expect(hd == ANCHOR_LARGE_HEAD_FEMALE)
}

/// Captured from deterministic output on Apple platforms; update if art changes.
private let ANCHOR_TALL_LIGHT_MALE: UInt64 = 2_459_379_329_161_092_885
private let ANCHOR_SHORT_HEAVY_FEMALE: UInt64 = 16_750_201_747_489_600_513
private let ANCHOR_LONG_ARMS: UInt64 = 1_873_878_755_639_238_629
private let ANCHOR_LARGE_HEAD_FEMALE: UInt64 = 5_654_733_151_769_712_949
