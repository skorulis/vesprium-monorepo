//  Created by Alexander Skorulis on 4/4/2026.

/// Hairstyle for the pixel character. Default ``short`` matches the original cap + side detail.
public enum HairStyle: Equatable, Sendable, CaseIterable {
    /// Full cap on top of the head; long side pieces for ``Gender/female``.
    case short
    /// Very short band (buzz cut).
    case buzz
    /// Like ``short`` but longer side coverage.
    case long
    /// Cap plus a center tail visible from the front.
    case ponytail
    /// No hair.
    case bald
    /// Narrow strip on top, extending above the head outline.
    case mohawk
}
