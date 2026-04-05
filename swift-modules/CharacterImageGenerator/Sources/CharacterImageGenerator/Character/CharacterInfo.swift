import CoreGraphics

/// sRGB color for character rendering; components are `0...255`.
public struct RGB: Equatable, Sendable, Codable {
    public var r: UInt8
    public var g: UInt8
    public var b: UInt8

    public init(r: UInt8, g: UInt8, b: UInt8) {
        self.r = r
        self.g = g
        self.b = b
    }

    public func cgColor() -> CGColor {
        CGColor(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: 1
        )
    }
}

public enum Gender: Equatable, Sendable, CaseIterable {
    case male
    case female
    case unspecified
}

/// Describes visual parameters for a generated character.
public struct CharacterInfo: Equatable, Sendable {
    public var face: FaceParams
    public var body: BodyParams
    public var clothes: Clothes

    public init(face: FaceParams = FaceParams(), body: BodyParams = BodyParams(), clothes: Clothes = Clothes()) {
        self.face = face
        self.body = body
        self.clothes = clothes
    }
    
    func with(clothes: Clothes) -> CharacterInfo {
        var result = self
        result.clothes = clothes
        return result
    }

    /// Convenience initializer matching the previous flat ``CharacterInfo`` API.
    public init(
        gender: Gender = .unspecified,
        skinColor: RGB = RGB(r: 220, g: 180, b: 150),
        hairColor: RGB = RGB(r: 60, g: 40, b: 25),
        hairStyle: HairStyle = .short,
        eyeColor: RGB? = nil,
        height: CGFloat = 1.0,
        weight: CGFloat = 1.0,
        armLength: CGFloat = 1.0,
        headSize: CGFloat = 1.0,
        legWear: LegWear? = nil,
        topWear: TopWear? = nil
    ) {
        self.face = FaceParams(
            skinColor: skinColor,
            hairColor: hairColor,
            hairStyle: hairStyle,
            eyeColor: eyeColor,
            headSize: headSize
        )
        self.body = BodyParams(
            gender: gender,
            height: height,
            weight: weight,
            armLength: armLength
        )
        self.clothes = Clothes(legWear: legWear, topWear: topWear)
    }
}
