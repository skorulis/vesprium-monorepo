//  Created by Alex Skorulis on 14/4/2026.

import Foundation
import Util

public enum DerivedAttribute: String, Codable, CaseIterable, Hashable, Sendable, CustomStringConvertible {

    case damage

    // Absolute damage reduction
    case damageAbsorbtion

    // How much further physical exertion can be pushed over 100%
    case physicalExertion

    public var description: String {
        rawValue.fromCaseName
    }
}
