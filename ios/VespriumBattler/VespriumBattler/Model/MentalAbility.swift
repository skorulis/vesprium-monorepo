// Created by Alexander Skorulis on 13/4/2026.

import BioStats
import Foundation
import SwiftUI
import Util

enum Ability: String, Codable, Sendable, Equatable, CaseIterable, ShopItem {

    // Boost physical aggressive
    case aggression
    
    case focusSpike
    case precisionStrike
    case psychicBlast

    private struct AbilityDetails {
        let text: String
        let duration: TimeInterval
        let strain: Strain
        let iconSystemName: String
        let attributeBonuses: [BioStats.AttributeBonus]
        let derivedAttributeBonuses: [DerivedAttributeBonus]
        let cost: Int
    }

    private var details: AbilityDetails {
        switch self {
        case .aggression:
            return AbilityDetails(
                text: "Boost damage by 50% for 2s",
                duration: 2,
                strain: Strain(physical: 5),
                iconSystemName: "arrow.2.circlepath.circle",
                attributeBonuses: [],
                derivedAttributeBonuses: [
                    DerivedAttributeBonus(attribute: .damage, value: 50, kind: .multiplicative),
                ],
                cost: 0 // Not purchaseable
            )
        case .focusSpike:
            return AbilityDetails(
                text: "Slows player perception of time for 5s",
                duration: 5,
                strain: Strain(mental: 7),
                iconSystemName: "sparkle",
                attributeBonuses: [],
                derivedAttributeBonuses: [],
                cost: 150
            )
        case .precisionStrike:
            return AbilityDetails(
                text: "50% higher chance to hit",
                duration: 2,
                strain: Strain(mental: 5),
                iconSystemName: "dot.scope",
                attributeBonuses: [],
                derivedAttributeBonuses: [
                    DerivedAttributeBonus(attribute: .hitChance, value: 50, kind: .multiplicative),
                ],
                cost: 150
            )
        case .psychicBlast:
            return AbilityDetails(
                text: "Emits mental energy to stun enemies",
                duration: 0,
                strain: Strain(mental: 8),
                iconSystemName: "brain",
                attributeBonuses: [],
                derivedAttributeBonuses: [],
                cost: 0 // Not purchaseable
            )
        }
    }

    var id: String { rawValue }
    var name: String { rawValue.fromCaseName }
    var text: String { details.text }
    var duration: TimeInterval { details.duration }
    var strain: Strain { details.strain }
    var icon: Image { Image(systemName: details.iconSystemName) }
    var attributeBonuses: [BioStats.AttributeBonus] { details.attributeBonuses }
    var derivedAttributeBonuses: [DerivedAttributeBonus] { details.derivedAttributeBonuses }
    var cost: Int { details.cost }
    var grantedAbility: Ability? { self }
}
