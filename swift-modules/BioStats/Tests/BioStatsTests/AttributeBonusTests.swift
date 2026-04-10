import Foundation
import Testing
@testable import BioStats

struct AttributeBonusTests {
    @Test func adjustedValueAdditiveOnly() {
        let bonuses = [
            AttributeBonus(attribute: .strength, value: 3, kind: .additive),
            AttributeBonus(attribute: .strength, value: 2, kind: .additive),
        ]
        #expect(AttributeBonus.adjustedValue(base: 10, bonuses: bonuses, attribute: .strength) == 15)
    }

    @Test func adjustedValueMultiplicativeOnly() {
        // 100 * (100 + 10) / 100 = 110
        let bonuses = [
            AttributeBonus(attribute: .agility, value: 10, kind: .multiplicative)
        ]
        #expect(AttributeBonus.adjustedValue(base: 100, bonuses: bonuses, attribute: .agility) == 110)
    }

    @Test func adjustedValueMultiplicativeCompound() {
        // 100 * 110/100 * 115/100 = 110 * 115 / 100 = 126
        let bonuses = [
            AttributeBonus(attribute: .vitality, value: 10, kind: .multiplicative),
            AttributeBonus(attribute: .vitality, value: 15, kind: .multiplicative),
        ]
        #expect(AttributeBonus.adjustedValue(base: 100, bonuses: bonuses, attribute: .vitality) == 126)
    }

    @Test func adjustedValueAdditiveThenMultiplicative() {
        // (10 + 5) * 120 / 100 = 18
        let bonuses = [
            AttributeBonus(attribute: .intelligence, value: 5, kind: .additive),
            AttributeBonus(attribute: .intelligence, value: 20, kind: .multiplicative),
        ]
        #expect(AttributeBonus.adjustedValue(base: 10, bonuses: bonuses, attribute: .intelligence) == 18)
    }

    @Test func adjustedValueIgnoresOtherAttributes() {
        let bonuses = [
            AttributeBonus(attribute: .strength, value: 100, kind: .additive),
            AttributeBonus(attribute: .charisma, value: 7, kind: .additive),
        ]
        #expect(AttributeBonus.adjustedValue(base: 10, bonuses: bonuses, attribute: .charisma) == 17)
    }

    @Test func adjustedValueNegativeAdditive() {
        let bonuses = [
            AttributeBonus(attribute: .stability, value: -3, kind: .additive)
        ]
        #expect(AttributeBonus.adjustedValue(base: 10, bonuses: bonuses, attribute: .stability) == 7)
    }

    @Test func adjustedValueNegativeMultiplicative() {
        // 200 * (100 - 50) / 100 = 100
        let bonuses = [
            AttributeBonus(attribute: .charisma, value: -50, kind: .multiplicative)
        ]
        #expect(AttributeBonus.adjustedValue(base: 200, bonuses: bonuses, attribute: .charisma) == 100)
    }

    @Test func defaultKindIsAdditive() {
        let bonus = AttributeBonus(attribute: .strength, value: 4)
        #expect(bonus.kind == .additive)
        #expect(AttributeBonus.adjustedValue(base: 10, bonuses: [bonus], attribute: .strength) == 14)
    }

}
