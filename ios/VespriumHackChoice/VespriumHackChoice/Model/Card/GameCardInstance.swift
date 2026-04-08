//  Created by Alex Skorulis on 8/4/2026.

import Foundation
import BioStats

struct GameCardInstance: Codable, Sendable, Equatable {
    let date: VespriumDate
    let card: GameCard
}
