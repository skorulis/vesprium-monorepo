//  Created by Alex Skorulis on 14/4/2026.

import Foundation

public enum DerivedAttribute: String, Codable, CaseIterable, Hashable, Sendable, CustomStringConvertible {
 
    case damage
    
    public var description: String { rawValue.capitalized }
}
