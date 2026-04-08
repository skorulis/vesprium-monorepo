import BioStats
import Foundation
import Testing
@testable import VespriumHackChoice

@MainActor
struct GameServiceTests {

    let assembly = VespriumHackChoiceAssembly.testing()
    var mainStore: MainStore { assembly.resolver.mainStore() }
    var gameService: GameService { assembly.resolver.gameService() }

    @Test func gymYearlyBonusAppliesOnEachHeldYearAnniversary() {
        var player = mainStore.player
        player.cards = PlayerCards(
            job: .farming,
            addedOn: SetupConstants.gameStartTime,
            activities: [
                GameCardInstance(date: SetupConstants.gameStartTime, card: .activity(.gym)),
            ]
        )
        let strengthBefore = player.attributes[.strength]
        mainStore.player = player

        var state = mainStore.gameState
        state.currentGameDate = SetupConstants.gameStartTime
        mainStore.gameState = state

        for _ in 0..<10 {
            gameService.advanceTime()
        }

        player = mainStore.player
        #expect(mainStore.gameState.currentGameDate == SetupConstants.gameStartTime.adding(years: 1))
        #expect(player.attributes[.strength] == strengthBefore + 1)
    }

    @Test func meditationHasNoYearlyAttributeBonus() {
        var player = mainStore.player
        player.cards = PlayerCards(
            job: .farming,
            addedOn: SetupConstants.gameStartTime,
            activities: [
                GameCardInstance(date: SetupConstants.gameStartTime, card: .activity(.meditation)),
            ]
        )
        let stabilityBefore = player.attributes[.stability]
        mainStore.player = player

        var state = mainStore.gameState
        state.currentGameDate = SetupConstants.gameStartTime
        mainStore.gameState = state

        for _ in 0..<10 {
            gameService.advanceTime()
        }

        player = mainStore.player
        #expect(player.attributes[.stability] == stabilityBefore)
    }
}
