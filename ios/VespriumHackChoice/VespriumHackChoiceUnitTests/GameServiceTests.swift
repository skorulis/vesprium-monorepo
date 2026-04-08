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
                GameCardInstance(date: SetupConstants.gameStartTime, card: .activity(.gym))
            ]
        )
        let strengthBefore = player.attributes[.strength]
        mainStore.player = player

        var state = mainStore.gameState
        state.currentGameDate = SetupConstants.gameStartTime
        state.currentYear = .zero
        state.pendingYearReview = nil
        state.pendingEvent = nil
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
                GameCardInstance(date: SetupConstants.gameStartTime, card: .activity(.meditation))
            ]
        )
        let stabilityBefore = player.attributes[.stability]
        mainStore.player = player

        var state = mainStore.gameState
        state.currentGameDate = SetupConstants.gameStartTime
        state.currentYear = .zero
        state.pendingYearReview = nil
        state.pendingEvent = nil
        mainStore.gameState = state

        for _ in 0..<10 {
            gameService.advanceTime()
        }

        player = mainStore.player
        #expect(player.attributes[.stability] == stabilityBefore)
    }

    @Test func currentYearAccumulatesNetMoneyEachMonth() {
        var player = mainStore.player
        player.cards = PlayerCards(
            job: .farming,
            addedOn: SetupConstants.gameStartTime,
            activities: []
        )
        mainStore.player = player
        var state = mainStore.gameState
        state.currentGameDate = SetupConstants.gameStartTime
        state.currentYear = .zero
        state.pendingYearReview = nil
        state.pendingEvent = nil
        mainStore.gameState = state

        let expectedDelta = GameCalculator(player: player).monthlyBalanceChange()
        gameService.advanceTime()
        #expect(mainStore.gameState.currentYear.moneyNetChange == expectedDelta)
    }

    @Test func yearEndReviewCapturesCompletedYearTotalsAndResetsAccumulator() {
        var player = mainStore.player
        player.cards = PlayerCards(
            job: .farming,
            addedOn: SetupConstants.gameStartTime,
            activities: []
        )
        mainStore.player = player
        var state = mainStore.gameState
        state.currentGameDate = SetupConstants.gameStartTime
        state.currentYear = .zero
        state.pendingYearReview = nil
        state.pendingEvent = nil
        mainStore.gameState = state

        let monthly = GameCalculator(player: player).monthlyBalanceChange()
        for _ in 0..<10 {
            gameService.advanceTime()
        }

        let review = mainStore.gameState.pendingYearReview
        #expect(review != nil)
        #expect(review?.year == SetupConstants.gameStartTime.year)
        #expect(review?.totals.moneyNetChange == monthly * 10)
        #expect(mainStore.gameState.currentYear.moneyNetChange == 0)
    }

    @Test func resolveYearReviewClearsPendingReviewAndMayQueueEvent() {
        var player = mainStore.player
        player.cards = PlayerCards(
            job: .farming,
            addedOn: SetupConstants.gameStartTime,
            activities: []
        )
        mainStore.player = player
        var state = mainStore.gameState
        state.currentGameDate = SetupConstants.gameStartTime
        state.currentYear = .zero
        state.pendingYearReview = nil
        state.pendingEvent = nil
        mainStore.gameState = state

        for _ in 0..<10 {
            gameService.advanceTime()
        }

        #expect(mainStore.gameState.pendingYearReview != nil)
        gameService.resolveYearReview()
        #expect(mainStore.gameState.pendingYearReview == nil)
    }
}
