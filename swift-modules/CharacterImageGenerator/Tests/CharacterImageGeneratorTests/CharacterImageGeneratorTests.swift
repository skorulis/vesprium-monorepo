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

private let customEyeColor = CharacterInfo(
    gender: .male,
    skinColor: RGB(r: 245, g: 220, b: 200),
    hairColor: RGB(r: 30, g: 25, b: 20),
    eyeColor: RGB(r: 64, g: 120, b: 200),
    height: 1.0,
    weight: 1.0,
    armLength: 1.0,
    headSize: 1.0
)

/// Width used for snapshot PNGs (height is `2 * snapshotWidth`).
private let snapshotWidth = 48

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
