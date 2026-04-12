//  Created by Alex Skorulis on 13/4/2026.

import BioStats
import Foundation

public struct EnhancementValues: Codable, Sendable, Equatable {
    
    public var installed: [BioEnhancement] = []
    
    public init() {
        
    }
    
    /// The collected bonuses from the installed enhancements
    public var attributeBonuses: [AttributeBonus] {
        return installed.flatMap { $0.attributeBonuses }
    }
    
    /// The total base strain from the installed components
    public var strain: Strain {
        return installed.reduce(Strain()) { $0 + $1.strain }
    }
}
