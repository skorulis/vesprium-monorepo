import Testing
@testable import VespriumHackChoice

@MainActor
struct MainStoreTests {

    let assembly = VespriumHackChoiceAssembly.testing()

    @Test func resetToNewGame_restoresPristineDefaults() {

        let mainStore = assembly.resolver.mainStore()
        var player = mainStore.player
        player.money = 999
        mainStore.player = player

        mainStore.resetToNewGame()

        // #expect(mainStore.isPristine)
        // #expect(mainStore.gameState == .init(currentGameDate: SetupConstants.gameStartTime))
        #expect(mainStore.player == PlayerCharacter(dateOfBirth: SetupConstants.defaultPlayerDOB))
    }

    @Test func isPristine_falseWhenMoneyChanged() {
        let mainStore = assembly.resolver.mainStore()
        var player = mainStore.player
        player.money += 1
        mainStore.player = player

        #expect(!mainStore.isPristine)
    }
}
