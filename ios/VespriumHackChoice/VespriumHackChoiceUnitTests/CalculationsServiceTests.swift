import BioStats
import Foundation
import Testing
@testable import VespriumHackChoice

@MainActor
struct CalculationServiceTests {

    let assembly = VespriumHackChoiceAssembly.testing()
    var mainStore: MainStore { assembly.resolver.mainStore() }
    var service: CalculationsService { assembly.resolver.calculationsService() }

    @Test @MainActor func farmingMonthlyEarningsSumsBaseAndIncomeBonuses() {
        var player = PlayerCharacter(dateOfBirth: SetupConstants.defaultPlayerDOB)
        player.attributes[.strength] = 12
        player.attributes[.vitality] = 10
        let earnings = GameCalculator(player: player).monthlyJobEarnings(for: .farming)
        // 120 + 2*12 + 2*10
        #expect(earnings == 164)
    }

    @Test @MainActor func farmingWithBarometricEarsIncreasesEarningsByFiftyPercent() {
        var player = PlayerCharacter(dateOfBirth: SetupConstants.defaultPlayerDOB)
        player.attributes[.strength] = 12
        player.attributes[.vitality] = 10
        player.cards = PlayerCards(bodyEnhancements: [
            .bodyEnhancement(.barometricEars)
        ])
        let earnings = GameCalculator(player: player).monthlyJobEarnings(for: .farming)
        // (120 + 2*12 + 2*10) * 3/2
        #expect(earnings == 246)
    }

    @Test @MainActor func shopKeeperMonthlyEarningsUsesCharismaAndIntelligence() {
        var player = PlayerCharacter(dateOfBirth: SetupConstants.defaultPlayerDOB)
        player.attributes[.charisma] = 15
        player.attributes[.cognition] = 8
        let earnings = GameCalculator(player: player).monthlyJobEarnings(for: .shopKeeper)
        // 100 + 2*15 + 2*8
        #expect(earnings == 146)
    }

    @Test @MainActor func shopKeeperIgnoresBarometricEars() {
        var player = PlayerCharacter(dateOfBirth: SetupConstants.defaultPlayerDOB)
        player.attributes[.charisma] = 15
        player.attributes[.cognition] = 8
        player.cards = PlayerCards(bodyEnhancements: [
            .bodyEnhancement(.barometricEars)
        ])
        let earnings = GameCalculator(player: player).monthlyJobEarnings(for: .shopKeeper)
        #expect(earnings == 146)
    }

    // MARK: - monthlyJobEarnings(for:) — uses MainStore.player

    @Test @MainActor func monthlyJobEarningsForJobUsesStorePlayerAttributes() {
        var player = mainStore.player
        player.attributes[.strength] = 11
        player.attributes[.vitality] = 9
        mainStore.player = player

        let earnings = service.monthlyJobEarnings(for: .farming)
        // 120 + 2*11 + 2*9
        #expect(earnings == 160)
    }

    @Test @MainActor func monthlyJobEarningsForFarmingAppliesBarometricEarsFromStore() {
        var player = mainStore.player
        player.attributes[.strength] = 11
        player.attributes[.vitality] = 9
        player.cards.bodyEnhancements = [
            .bodyEnhancement(.barometricEars)
        ]
        mainStore.player = player

        let earnings = service.monthlyJobEarnings(for: .farming)
        // (120 + 2*11 + 2*9) * 3/2
        #expect(earnings == 240)
    }

    @Test func monthlyBalanceChangeCombinesJobBonusesAndActivityCosts() {
        var player = PlayerCharacter(dateOfBirth: SetupConstants.defaultPlayerDOB)
        player.attributes[.strength] = 12
        player.attributes[.vitality] = 10
        player.cards = PlayerCards(
            job: .farming,
            activities: [
                .activity(.gym)
            ]
        )
        let net = GameCalculator(player: player).monthlyBalanceChange()
        // farming 164 − gym 20 − living expenses (20 + 12 + 30)
        #expect(net == 82)
    }
}
