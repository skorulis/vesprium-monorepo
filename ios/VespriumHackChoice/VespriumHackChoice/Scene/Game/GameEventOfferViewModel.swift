import ASKCoordinator
import ASKCore
import Knit
import KnitMacros
import Observation

@MainActor
@Observable
final class GameEventOfferViewModel: CoordinatorViewModel {
    weak var coordinator: ASKCoordinator.Coordinator?
    
    let event: GameEvent

    private let gameService: GameService

    @Resolvable<Resolver>
    init(gameService: GameService, @Argument event: GameEvent) {
        self.gameService = gameService
        self.event = event
    }

    func selectCard(_ card: GameCard) {
        gameService.resolvePendingEvent(selecting: card)
        coordinator?.retreat()
    }

    func skip() {
        gameService.resolvePendingEvent(selecting: nil)
        coordinator?.retreat()
    }
}
