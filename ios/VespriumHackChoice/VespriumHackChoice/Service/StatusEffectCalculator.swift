//  Created by Alexander Skorulis on 11/4/2026.

import Foundation

struct StatusEffectCalculator {
    let player: PlayerCharacter
    
    func statusEffectApplies(effect: StatusEffectKind) -> Bool {
        switch effect {
        case .heatWave, .coldSnap:
            return player.job?.flags.contains(.outdoors) == true
        }
    }
    
    func statusEffectImpact(effect: StatusEffectKind) -> StatusEffectImpact {
        guard statusEffectApplies(effect: effect) else {
            return .none
        }
        return .init(strain: effect.strain)
    }
}
