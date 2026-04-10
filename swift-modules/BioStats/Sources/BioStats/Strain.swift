//  Created by Alexander Skorulis on 10/4/2026.

import Foundation

/// Strain represents the toll that is being applied to the body by actions or implants
public struct Strain: Equatable, Sendable {
    public let physical: Int
    public let mental: Int

    public init(physical: Int = 0, mental: Int = 0) {
        self.physical = physical
        self.mental = mental
    }

    public func normalized() -> Strain {
        Strain(physical: max(physical, 0), mental: max(mental, 0))
    }

    public static func + (lhs: Strain, rhs: Strain) -> Strain {
        return Strain(physical: lhs.physical + rhs.physical, mental: lhs.mental + rhs.mental)
    }

}
