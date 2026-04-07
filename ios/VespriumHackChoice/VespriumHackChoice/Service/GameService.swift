import ASKCore
import BioStats
import Combine
import Foundation
import Knit
import KnitMacros

@MainActor
final class GameService: ObservableObject {
    private let store: MainStore
    private var tickTask: Task<Void, Never>?

    @Published private(set) var isPlaying = false

    @Resolvable<Resolver>
    init(store: MainStore) {
        self.store = store
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
        isPlaying = true
        tickTask = Task { @MainActor in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(0.5))
                guard !Task.isCancelled else { break }
                guard self.isPlaying else { break }
                var state = self.store.gameState
                let previousDate = state.currentGameDate
                let newDate = previousDate.adding(days: 1)
                state.currentGameDate = newDate
                self.store.gameState = state

                if Self.hasCrossedIntoNewMonth(from: previousDate, to: newDate) {
                    executeMonthChanges()
                }
            }
        }
    }
    
    private func executeMonthChanges() {
        var player = self.store.player
        player.money += player.job.monthlyIncome
        self.store.player = player
    }

    func stop() {
        isPlaying = false
        tickTask?.cancel()
        tickTask = nil
    }

    private static func hasCrossedIntoNewMonth(from previous: VespriumDate, to next: VespriumDate) -> Bool {
        previous.year != next.year || previous.month != next.month
    }
}
