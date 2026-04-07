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
                try? await Task.sleep(for: .seconds(1))
                guard !Task.isCancelled else { break }
                guard self.isPlaying else { break }
                var state = self.store.gameState
                state.currentGameDate = state.currentGameDate.adding(days: 1)
                self.store.gameState = state
            }
        }
    }

    func stop() {
        isPlaying = false
        tickTask?.cancel()
        tickTask = nil
    }
}
