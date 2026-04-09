import Foundation
import Testing
@testable import BioStats

struct AttributeValuesBonusTests {
    @Test func applyingBonusesEmptyLeavesValuesUnchanged() {
        var values = AttributeValues()
        values[.strength] = 12
        values[.agility] = 8
        let adjusted = values.applyingBonuses([])
        #expect(adjusted[.strength] == 12)
        #expect(adjusted[.agility] == 8)
    }

    @Test func applyingBonusesAdditiveAcrossAttributes() {
        var values = AttributeValues()
        values[.strength] = 10
        values[.intelligence] = 20
        let bonuses = [
            AttributeBonus(attribute: .strength, value: 2, kind: .additive),
            AttributeBonus(attribute: .intelligence, value: 5, kind: .additive),
        ]
        let adjusted = values.applyingBonuses(bonuses)
        #expect(adjusted[.strength] == 12)
        #expect(adjusted[.intelligence] == 25)
        // Unaffected attributes stay at default
        #expect(adjusted[.agility] == Attribute.defaultValue)
    }

    @Test func applyingBonusesMultiplicativeAndAdditiveMatchPerAttributeAdjustedValue() {
        var values = AttributeValues()
        values[.vitality] = 100
        let bonuses = [
            AttributeBonus(attribute: .vitality, value: 10, kind: .multiplicative),
            AttributeBonus(attribute: .vitality, value: 15, kind: .multiplicative),
        ]
        let adjusted = values.applyingBonuses(bonuses)
        let expected = AttributeBonus.adjustedValue(base: 100, bonuses: bonuses, attribute: .vitality)
        #expect(adjusted[.vitality] == expected)
        #expect(adjusted[.vitality] == 126)
    }
    
    @Test func applyingBonusesOrdered() {
        var values = AttributeValues()
        values[.charisma] = 10
        let bonuses = [
            AttributeBonus(attribute: .charisma, value: 100, kind: .multiplicative),
            AttributeBonus(attribute: .charisma, value: 10, kind: .additive),
        ]
        let adjusted = values.applyingBonuses(bonuses)
        #expect(adjusted[.charisma] == 40)
    }
}
