import ASKCore
import Combine
import Foundation
import Knit
import KnitMacros

@MainActor
final class GameService: ObservableObject {
    private let store: MainStore
    private let eventGenerator: EventGenerator
    private var tickTask: Task<Void, Never>?

    @Published private(set) var isPlaying = false

    @Resolvable<Resolver>
    init(store: MainStore, eventGenerator: EventGenerator) {
        self.store = store
        self.eventGenerator = eventGenerator
    }

    func toggle() {
        if isPlaying {
            stop()
        } else {
            start()
        }
    }

    func start() {
        guard !isPlaying else { return }
        guard store.gameState.pendingEvent == nil else { return }
        isPlaying = true
        tickTask = Task { @MainActor in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(5))
                guard !Task.isCancelled else { break }
                guard self.isPlaying else { break }
                guard self.store.gameState.pendingEvent == nil else { break }
                var state = self.store.gameState
                let newDate = state.currentGameDate.adding(months: 1)
                state.currentGameDate = newDate
                self.store.gameState = state
                self.executeMonthChanges()
                if let event = self.eventGenerator.nextEvent() {
                    state = self.store.gameState
                    state.pendingEvent = event
                    self.store.gameState = state
                    self.stop()
                    break
                }
            }
        }
    }

    private func executeMonthChanges() {
        var player = self.store.player
        player.money += player.cards.monthlyBalanceChange
        self.store.player = player
    }

    func stop() {
        isPlaying = false
        tickTask?.cancel()
        tickTask = nil
    }

    func resolvePendingEvent(selecting card: GameCard?) {
        guard let event = store.gameState.pendingEvent else { return }
        if let card {
            var player = store.player
            player.cards.add(card: card)
            store.player = player
        } else {
            guard event.skippable else { return }
        }
        var state = store.gameState
        state.pendingEvent = nil
        store.gameState = state
        self.start()
    }
}
