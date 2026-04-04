//  Created by Alexander Skorulis on 5/4/2026.

import CoreGraphics

/// Body proportions and identity for a generated character.
///
/// Proportion values use `0.5...1.5` with `1.0` as a neutral baseline.
public struct BodyParams: Equatable, Sendable {
    public var gender: Gender
    /// Vertical scale for legs and torso span.
    public var height: CGFloat
    /// Horizontal scale for torso and legs.
    public var weight: CGFloat
    /// Scale for arm length (from shoulder downward).
    public var armLength: CGFloat

    public init(
        gender: Gender = .unspecified,
        height: CGFloat = 1.0,
        weight: CGFloat = 1.0,
        armLength: CGFloat = 1.0
    ) {
        self.gender = gender
        self.height = height
        self.weight = weight
        self.armLength = armLength
    }
}
