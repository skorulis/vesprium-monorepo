// Created by Alexander Skorulis on 2/3/2026.
//
// Represents a probability as a fraction between 0 and 1.

import Foundation

public struct Chance: Codable, Hashable {

    public let value: Double

    /// Creates a chance from a fractional value between 0 and 1.
    /// Values above 1 can be treated in different ways
    public init(_ fraction: Double) {
        self.value = fraction
    }

    public init(percent: Int) {
        self.value = Double(percent) / 100
    }

    /// The underlying fractional value, guaranteed to be between 0 and 1.
    public var fraction: Double { value }

    /// Returns the chance formatted as a percentage string, e.g. "12.5%".
    public func percentageString(decimalPlaces: Int = 1) -> String {
        let format = "%.\(decimalPlaces)f%%"
        return String(format: format, fraction * 100)
    }

    public func check() -> Bool {
        if fraction == 0 {
            return false
        }
        let roll = Double.random(in: 0...1)
        return roll <= fraction
    }

    /// Perform a check with the possibility of the chance being over 1
    public func bonus() -> Int {
        let guaranteed = Int(fraction)
        let remainder = fraction - Double(guaranteed)
        let roll = Double.random(in: 0...1)
        return roll <= remainder ? 1 + guaranteed : guaranteed
    }

    public func adding(percent: Int) -> Chance {
        let newValue = value + (Double(percent) / 100)
        return Chance(newValue)
    }

    public func multiplying(percent: Int) -> Chance {
        let newValue = value * (1 + Double(percent) / 100)
        return Chance(newValue)
    }
}
