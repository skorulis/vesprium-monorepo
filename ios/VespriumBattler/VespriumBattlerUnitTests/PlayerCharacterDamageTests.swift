import BioEnhancements
import BioStats
import Testing
@testable import VespriumBattler

struct PlayerCharacterDamageTests {

    @Test func damageUsesHalfStrengthWithIntegerDivision() {
        var player = PlayerCharacter()
        player.attributes[.strength] = 11

        #expect(player.damage == 5)
    }

    @Test func damageIncludesStrengthEnhancementBonuses() {
        var player = PlayerCharacter()
        player.attributes[.strength] = 10
        player.enhancements.installed = [.muscleEnergyImplants]

        // 10 strength boosted by +50% = 15, then base damage is 15 / 2.
        #expect(player.damage == 7)
    }

    @Test func raptorClawsIncreaseDamageByFiftyPercent() {
        var player = PlayerCharacter()
        player.attributes[.strength] = 12
        player.enhancements.installed = [.raptorClaws]

        // Base damage: 12 / 2 = 6, then +50% derived damage bonus.
        #expect(player.damage == 9)
    }
}
