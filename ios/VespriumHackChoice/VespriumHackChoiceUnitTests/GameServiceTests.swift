import BioEnhancements
import BioStats
import Foundation
import Testing
@testable import VespriumHackChoice

@MainActor
struct GameServiceTests {

    let assembly = VespriumHackChoiceAssembly.testing()
    var mainStore: MainStore { assembly.resolver.mainStore() }
    var gameService: GameService { assembly.resolver.gameService() }

    @Test func gymYearlyBonusAppliesWhenYearEndReviewIsResolved() {
        var player = mainStore.player
        player.cards = PlayerCards(
            job: .farming,
            activities: [
                .activity(.gym)
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
        #expect(player.attributes[.strength] == strengthBefore)
        #expect(mainStore.gameState.pendingYearReview?.totals.attributeIncreases[.strength] == 1)

        gameService.resolveYearReview()
        player = mainStore.player
        #expect(player.attributes[.strength] == strengthBefore + 1)
    }

    @Test func meditationHasNoYearlyAttributeBonus() {
        var player = mainStore.player
        player.cards = PlayerCards(
            job: .farming,
            activities: [
                .activity(.meditation)
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
        #expect(mainStore.gameState.pendingYearReview?.totals.attributeIncreases[.stability] == nil)

        gameService.resolveYearReview()
        player = mainStore.player
        #expect(player.attributes[.stability] == stabilityBefore)
    }

    @Test func currentYearAccumulatesNetMoneyEachMonth() {
        var player = mainStore.player
        player.cards = PlayerCards(
            job: .farming,
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

    @Test func yearBoundaryWeaknessFailureReducesVitalityByOne() {
        var player = mainStore.player
        player.attributes[.vitality] = 10
        mainStore.player = player

        var state = mainStore.gameState
        state.currentGameDate = SetupConstants.gameStartTime
        state.currentYear = .zero
        state.pendingYearReview = nil
        state.pendingEvent = nil
        mainStore.gameState = state

        // Age is <= 20 by default, so weakness chance is 0 and the check always fails.
        for _ in 0..<10 {
            gameService.advanceTime()
        }

        #expect(mainStore.player.attributes[.vitality] == 9)
        #expect(mainStore.gameState.pendingYearReview?.totals.attributeIncreases[.vitality] == -1)
    }

    @Test func selectingPricedCardDeductsCostFromMoneyAndYearTotals() {
        var player = mainStore.player
        player.money = 500
        mainStore.player = player

        let card = GameCard.bodyEnhancement(.chlorophyllSkin)
        let price = card.price

        var state = mainStore.gameState
        state.currentGameDate = SetupConstants.gameStartTime
        state.currentYear = .zero
        state.pendingYearReview = nil
        state.pendingEvent = GameEvent(
            text: "Choose",
            cards: [card],
            skippable: true
        )
        mainStore.gameState = state

        let moneyBefore = mainStore.player.money
        gameService.resolvePendingEvent(selecting: card)

        #expect(mainStore.player.money == moneyBefore - price)
        #expect(mainStore.gameState.currentYear.moneyNetChange == -price)
        #expect(mainStore.player.cards.hasEnhancement(.chlorophyllSkin))
        #expect(mainStore.gameState.pendingEvent == nil)
    }

    @Test func yearlyCardChoiceOfferedOnlyOnOddCompletedYears() {
        #expect(EventGenerator.shouldOfferYearlyCardChoice(forCompletedYear: 1250) == false)
        #expect(EventGenerator.shouldOfferYearlyCardChoice(forCompletedYear: 1251) == true)
    }

    @Test func advanceTimeWithJobAndActivityQueuesMonthlyEvent() {
        var player = mainStore.player
        player.cards = PlayerCards(
            job: .farming,
            activities: [.activity(.school)]
        )
        mainStore.player = player
        var state = mainStore.gameState
        state.currentGameDate = SetupConstants.gameStartTime
        state.currentYear = .zero
        state.pendingYearReview = nil
        state.pendingEvent = nil
        mainStore.gameState = state

        gameService.advanceTime()

        #expect(mainStore.gameState.pendingEvent != nil)
        guard let pick = mainStore.gameState.pendingEvent?.cards.first else {
            Issue.record("Expected monthly or other event with cards")
            return
        }
        gameService.resolvePendingEvent(selecting: pick)
        #expect(mainStore.gameState.pendingEvent == nil)
    }

    @Test func monthlyChoiceMoneyDeltaAppliesWithoutAddingCard() {
        let option = MonthlyChoiceOption(
            id: "test_money",
            title: "Coin bonus",
            hint: "+10 coins",
            effect: .moneyDelta(10)
        )
        var player = mainStore.player
        player.cards = PlayerCards(job: .farming, activities: [.activity(.school)])
        let moneyBefore = player.money
        mainStore.player = player
        var state = mainStore.gameState
        state.currentGameDate = SetupConstants.gameStartTime
        state.pendingEvent = GameEvent(
            text: "Test",
            cards: [.monthlyChoice(option)],
            skippable: true
        )
        mainStore.gameState = state

        gameService.resolvePendingEvent(selecting: .monthlyChoice(option))

        #expect(mainStore.player.money == moneyBefore + 10)
        #expect(mainStore.player.cards.activities.count == 1)
    }

    @Test func yearBoundaryRefreshesShopInventoryWithoutDuplicates() {
        var player = mainStore.player
        player.cards = PlayerCards(
            job: .farming,
            activities: [],
            bodyEnhancements: [.bodyEnhancement(.chlorophyllSkin)]
        )
        mainStore.player = player

        var state = mainStore.gameState
        state.currentGameDate = SetupConstants.gameStartTime
        state.currentYear = .zero
        state.pendingYearReview = nil
        state.pendingEvent = nil
        state.shopEnhancements = [.barometricEars]
        state.shopLastRefreshYear = nil
        mainStore.gameState = state

        for _ in 0..<10 {
            gameService.advanceTime()
        }

        let refreshed = mainStore.gameState.shopEnhancements
        #expect(refreshed.count == min(3, BioEnhancement.allCases.count))
        #expect(Set(refreshed.map(\.rawValue)).count == refreshed.count)
        #expect(mainStore.gameState.shopLastRefreshYear == SetupConstants.gameStartTime.adding(years: 1).year)
        #expect(refreshed.contains(.chlorophyllSkin))
    }

    @Test func purchaseShopEnhancementHandlesSuccessAndAlreadyOwned() {
        var player = mainStore.player
        player.money = 500
        player.cards = PlayerCards(job: .farming, activities: [])
        mainStore.player = player

        var state = mainStore.gameState
        state.currentYear = .zero
        mainStore.gameState = state

        let purchaseResult = gameService.purchaseShopEnhancement(.chlorophyllSkin)
        #expect(purchaseResult == .purchased)
        #expect(mainStore.player.cards.hasEnhancement(.chlorophyllSkin))
        #expect(mainStore.player.money == 400)
        #expect(mainStore.gameState.currentYear.moneyNetChange == -100)

        let secondAttempt = gameService.purchaseShopEnhancement(.chlorophyllSkin)
        #expect(secondAttempt == .alreadyOwned)
        #expect(mainStore.player.money == 400)
        #expect(mainStore.gameState.currentYear.moneyNetChange == -100)
    }

    @Test func yearBoundaryWeaknessSuccessDoesNotReduceVitality() {
        var player = mainStore.player
        player.dateOfBirth = SetupConstants.gameStartTime.adding(years: -100)
        player.attributes[.vitality] = 0
        mainStore.player = player

        var state = mainStore.gameState
        state.currentGameDate = SetupConstants.gameStartTime
        state.currentYear = .zero
        state.pendingYearReview = nil
        state.pendingEvent = nil
        mainStore.gameState = state

        // At age 100+ with zero vitality, weakness chance is 100 and the check always succeeds.
        for _ in 0..<10 {
            gameService.advanceTime()
        }

        #expect(mainStore.player.attributes[.vitality] == 0)
    }
}
