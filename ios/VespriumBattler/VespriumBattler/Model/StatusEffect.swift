// Created by Alex Skorulis on 16/4/2026.

import Foundation

enum StatusEffect: String, Codable, Sendable, Equatable {
    // Unable to attack
    case stun
}

struct StatusEffectContainer: Codable, Sendable, Equatable {
    var effects: [StatusEffect: TimeInterval] = [:]
    
    func contains(effect: StatusEffect) -> Bool {
        return effects[effect, default: 0] > 0
    }
    
    mutating func add(effect: StatusEffect, duration: Double) {
        effects[effect] = duration
    }
    
    mutating func reduce(time: TimeInterval) {
        for (key, value) in effects {
            let newValue = value - time
            if newValue <= 0 {
                effects.removeValue(forKey: key)
            } else {
                effects[key] = newValue
            }
        }
    }
}
