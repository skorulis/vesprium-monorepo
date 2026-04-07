//  Created by Alex Skorulis on 7/4/2026.

import Foundation

struct GameEvent: Sendable, Codable {
    let text: String
    let choices: [EventChoice]
}

struct EventChoice: Sendable, Codable {
    let text: String
    let result: EventResult
    let cost: Int
}

enum EventResult: Sendable, Codable {

    // Change to a new job
    case changeJob(Job)
}
