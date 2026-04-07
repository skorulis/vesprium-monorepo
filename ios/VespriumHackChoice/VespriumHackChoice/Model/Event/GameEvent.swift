//  Created by Alex Skorulis on 7/4/2026.

import Foundation

struct GameEvent: Sendable {
    let text: String
    let choices: [EventChoice]
}

struct EventChoice: Sendable {
    let text: String
    let result: EventResult
    let cost: Int
}

enum EventResult: Sendable {
    
    // Change to a new job
    case changeJob(Job)
}
