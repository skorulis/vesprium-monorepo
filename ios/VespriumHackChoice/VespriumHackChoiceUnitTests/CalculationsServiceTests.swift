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
        var attributes = AttributeValues()
        attributes[.strength] = 12
        attributes[.vitality] = 10
        let earnings = service.monthlyJobEarnings(for: .farming, attributes: attributes)
        // 120 + 2*12 + 2*10
        #expect(earnings == 164)
    }

    @Test @MainActor func shopKeeperMonthlyEarningsUsesCharismaAndIntelligence() {
        var attributes = AttributeValues()
        attributes[.charisma] = 15
        attributes[.intelligence] = 8
        let earnings = service.monthlyJobEarnings(for: .shopKeeper, attributes: attributes)
        // 100 + 2*15 + 2*8
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
}
