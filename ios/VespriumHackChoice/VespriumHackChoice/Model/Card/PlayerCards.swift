//  Created by Alex Skorulis on 8/4/2026.

import Foundation

struct PlayerCards: Codable, Sendable, Equatable {
    var job: Job?

    var jobCard: GameCard? { return job.map { .job($0) } }
    
    var allCards: [GameCard] {
        return [jobCard].compactMap(\.self)
    }
}
