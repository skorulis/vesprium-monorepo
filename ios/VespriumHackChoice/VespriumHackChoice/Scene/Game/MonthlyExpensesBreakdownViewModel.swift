import ASKCore
import Combine
import Knit
import KnitMacros
import Observation

@MainActor
@Observable
final class MonthlyExpensesBreakdownViewModel {
    private(set) var breakdown: GameCalculator.MonthlyLivingExpensesBreakdown

    private var cancellables: Set<AnyCancellable> = []

    @Resolvable<Resolver>
    init(mainStore: MainStore) {
        self.breakdown = GameCalculator(player: mainStore.player).monthlyLivingExpensesBreakdown()

        mainStore.$player.sink { [unowned self] in
            self.breakdown = GameCalculator(player: $0).monthlyLivingExpensesBreakdown()
        }
        .store(in: &cancellables)
    }
}
