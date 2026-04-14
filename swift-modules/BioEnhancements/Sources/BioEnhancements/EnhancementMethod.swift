//  Created by Alexander Skorulis on 14/4/2026.

import Foundation

public enum EnhancementMethod: String, Codable, Sendable, Equatable, CaseIterable {
    case geneGraft
    case mechanicalImplant
    case surgery

    case unknown

    var text: String {
        switch self {
        case .geneGraft:
            return "Grafting genes from another organism"
        case .mechanicalImplant:
            return "Implanting with some form of technology"
        case .surgery:
            return "Surgery"
        case .unknown:
            return "Unknown"
        }
    }
}
