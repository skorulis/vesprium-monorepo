import ASKCore
import BioStats
import Combine
import Foundation
import Knit
import KnitMacros

@MainActor
final class GameService: ObservableObject {
    private let store: MainStore
    private let eventGenerator: EventGenerator
    private let calculationsService: CalculationsService

    @Resolvable<Resolver>
    init(store: MainStore, eventGenerator: EventGenerator, calculationsService: CalculationsService) {
        self.store = store
        self.eventGenerator = eventGenerator
        self.calculationsService = calculationsService
    }

    func advanceTime() {
        var state = self.store.gameState
        let newDate = state.currentGameDate.adding(months: 1)
        state.currentGameDate = newDate
        self.store.gameState = state
        self.executeMonthChanges()
        if let event = self.eventGenerator.nextEvent() {
            state = self.store.gameState
            state.pendingEvent = event
            self.store.gameState = state
        }
    }

    private func executeMonthChanges() {
        var player = self.store.player
        player.money += calculationsService.monthlyBalanceChange()
        self.store.player = player
    }

    func resolvePendingEvent(selecting card: GameCard?) {
        guard let event = store.gameState.pendingEvent else { return }
        if let card {
            var player = store.player
            player.cards.add(card: card, on: store.gameState.currentGameDate)
            store.player = player
        } else {
            guard event.skippable else { return }
        }
        var state = store.gameState
        state.pendingEvent = nil
        store.gameState = state
    }
}
