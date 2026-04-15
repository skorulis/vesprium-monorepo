//  Created by Alexander Skorulis on 7/4/2026.

import Foundation
import BioStats
import Util

public enum BioEnhancement: String, Codable, Sendable, Equatable, CaseIterable {
    case chlorophyllSkin
    case barometricEars
    case muscleEnergyImplants
    case brainOverclock
    case subdermalArmor
    case thickendedSkin
    case faceSculpting
    case socialPheromoneGlands
    case oxygenatedBlood
    case raptorClaws
    case retractableClaws
    case extraAdrenalGlands

    public var name: String {
        rawValue.fromCaseName
    }

    public var text: String {
        details.text
    }

    public var technicalDetails: String? {
        details.technicalDetails
    }

    public var baseCost: Int {
        details.baseCost
    }

    public var attributeBonuses: [AttributeBonus] {
        details.attributeBonuses
    }

    public var derivedAttributeBonuses: [DerivedAttributeBonus] { details.derivedAttributeBonuses }

    public var strain: Strain { details.strain }

    public var method: EnhancementMethod { details.method }

    public var excludes: Set<BioEnhancement> { details.excludes }

    private var details: EnhancementDetails {
        switch self {
        case .chlorophyllSkin:
            return .init(
                text: "Absorbs energy from the sun to reduce food needs",
                baseCost: 100,
                attributeBonuses: [AttributeBonus(attribute: .stability, value: -1)],
                strain: .init(physical: 1),
                method: .geneGraft
            )
        case .barometricEars:
            return .init(
                text: "Eardrums sensitive enough to detect changes in barometric pressure",
                baseCost: 100,
                method: .mechanicalImplant
            )
        case .muscleEnergyImplants:
            return .init(
                text: "Implants that hold energy that give a boost to strength when needed",
                technicalDetails: "Fairly simple biological implants which store excess energy while inactive and release it when the muscles are under high stress",
                baseCost: 200,
                attributeBonuses: [AttributeBonus(attribute: .strength, value: 50, kind: .multiplicative)],
                strain: .init(physical: 2),
                method: .geneGraft
            )
        case .brainOverclock:
            return .init(
                text: "Forces the neurons in the brain to transmit faster increasing overall thought processing",
                technicalDetails: "A crystal and bio battery implanted in the back of the head provides a constant pulse which forces neurons to work overtime",
                baseCost: 500,
                attributeBonuses: [
                    AttributeBonus(attribute: .cognition, value: 50, kind: .multiplicative),
                    AttributeBonus(attribute: .agility, value: 25, kind: .multiplicative),
                ],
                strain: .init(physical: 0, mental: 1),
                method: .mechanicalImplant
            )
        case .subdermalArmor:
            return .init(
                text: "Metal plates embedded in the body's skin that reduces damage",
                baseCost: 200,
                derivedAttributeBonuses: [
                    DerivedAttributeBonus(attribute: .damageAbsorbtion, value: 1, kind: .additive)
                ],
                strain: .init(physical: 1),
                method: .mechanicalImplant
            )
        case .thickendedSkin:
            return .init(
                text: "Thicker skin that reduces damage",
                baseCost: 200,
                attributeBonuses: [
                    AttributeBonus(attribute: .charisma, value: -10, kind: .multiplicative),
                ],
                derivedAttributeBonuses: [
                    DerivedAttributeBonus(attribute: .damageAbsorbtion, value: 1, kind: .additive)
                ],
                strain: .init(physical: 1),
                method: .geneGraft
            )
        case .faceSculpting:
            return .init(
                text: "Brings out the natural beauty of the face",
                baseCost: 100,
                attributeBonuses: [
                    AttributeBonus(attribute: .charisma, value: 25, kind: .multiplicative),
                ],
                method: .surgery
            )
        case .socialPheromoneGlands:
            return .init(
                text: "Controlled pheromone release improves social influence",
                baseCost: 180,
                attributeBonuses: [
                    AttributeBonus(attribute: .charisma, value: 30, kind: .multiplicative),
                    AttributeBonus(attribute: .stability, value: -10, kind: .multiplicative),
                ],
                method: .geneGraft
            )
        case .oxygenatedBlood:
            return .init(
                text: "Engineered blood proteins carry oxygen more efficiently",
                baseCost: 260,
                attributeBonuses: [
                    AttributeBonus(attribute: .strength, value: 20, kind: .multiplicative),
                    AttributeBonus(attribute: .agility, value: 20, kind: .multiplicative),
                ],
                strain: .init(physical: 2),
                method: .geneGraft
            )
        case .raptorClaws:
            return .init(
                text: "Bone claws embedded into the fingers",
                baseCost: 150,
                attributeBonuses: [
                    AttributeBonus(attribute: .agility, value: -10, kind: .multiplicative),
                ],
                derivedAttributeBonuses: [
                    DerivedAttributeBonus(attribute: .damage, value: 50, kind: .multiplicative)
                ],
                strain: .init(physical: 1),
                method: .geneGraft,
                excludes: [.retractableClaws],
            )
        case .retractableClaws:
            return .init(
                text: "Metal claws that can be hidden back inside the hands when not in use",
                baseCost: 200,
                derivedAttributeBonuses: [
                    DerivedAttributeBonus(attribute: .damage, value: 50, kind: .multiplicative)
                ],
                strain: .init(physical: 2),
                method: .mechanicalImplant,
                excludes: [.raptorClaws],
            )
        case .extraAdrenalGlands:
            return .init(
                text: "Allows producing a higher level of adrenaline when needed",
                baseCost: 150,
                derivedAttributeBonuses: [
                    DerivedAttributeBonus(attribute: .maxPhysicalExertion, value: 50, kind: .multiplicative),
                ],
                strain: .init(physical: 1),
                method: .surgery,
            )
        }
    }

}

private struct EnhancementDetails {
    let text: String
    let technicalDetails: String?
    let baseCost: Int
    let attributeBonuses: [AttributeBonus]
    let derivedAttributeBonuses: [DerivedAttributeBonus]
    let strain: Strain
    let method: EnhancementMethod
    let excludes: Set<BioEnhancement>

    init(
        text: String,
        technicalDetails: String? = nil,
        baseCost: Int,
        attributeBonuses: [AttributeBonus] = [],
        derivedAttributeBonuses: [DerivedAttributeBonus] = [],
        strain: Strain = .none,
        method: EnhancementMethod,
        excludes: Set<BioEnhancement> = []
    ) {
        self.text = text
        self.technicalDetails = technicalDetails
        self.baseCost = baseCost
        self.attributeBonuses = attributeBonuses
        self.derivedAttributeBonuses = derivedAttributeBonuses
        self.strain = strain
        self.method = method
        self.excludes = excludes
    }
}
