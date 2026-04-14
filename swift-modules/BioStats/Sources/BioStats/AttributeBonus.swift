//  Created by Alexander Skorulis on 7/4/2026.

import Foundation

/// How an ``AttributeBonus`` combines with a base value.
public enum BonusKind: String, Codable, Sendable, Equatable {
    /// Adds ``AttributeBonus/value`` directly to the base (can be negative).
    case additive
    /// Treats ``AttributeBonus/value`` as a signed percentage change: each step applies
    /// `×(100 + value) / 100` using truncating integer division toward zero.
    case multiplicative
}

public struct Bonus<AttributeType: Equatable> {
    public let attribute: AttributeType
    public let value: Int
    public let kind: BonusKind
    
    public init(attribute: AttributeType, value: Int, kind: BonusKind = .additive) {
        self.attribute = attribute
        self.value = value
        self.kind = kind
    }

    /// Returns the base value after applying every bonus in `bonuses` that matches `attribute`.
    ///
    /// Processing order:
    /// 1. All additive bonuses for this attribute are summed and added to `base`.
    /// 2. Each multiplicative bonus applies in array order: `result = (result * (100 + value)) / 100`.
    public static func adjustedValue(base: Int, bonuses: [Bonus<AttributeType>], attribute: AttributeType) -> Int {
        let relevant = bonuses.filter { $0.attribute == attribute }
        let additiveSum = relevant
            .filter { $0.kind == .additive }
            .reduce(0) { $0 + $1.value }
        var result = base + additiveSum
        for bonus in relevant where bonus.kind == .multiplicative {
            result = (result * (100 + bonus.value)) / 100
        }
        return result
    }
}

public typealias AttributeBonus = Bonus<Attribute>
public typealias DerivedAttributeBonus = Bonus<DerivedAttribute>
