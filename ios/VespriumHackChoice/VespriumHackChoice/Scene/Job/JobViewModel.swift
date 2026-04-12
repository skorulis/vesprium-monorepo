import Combine
import Knit
import KnitMacros
import Observation

@MainActor
@Observable
final class JobViewModel {
    let gameService: GameService
    private let mainStore: MainStore

    var player: PlayerCharacter

    private var cancellables: Set<AnyCancellable> = []

    @Resolvable<Resolver>
    init(gameService: GameService, mainStore: MainStore) {
        self.gameService = gameService
        self.mainStore = mainStore
        self.player = mainStore.player

        mainStore.$player.sink { [unowned self] in
            self.player = $0
        }
        .store(in: &cancellables)
    }
}

extension JobViewModel {
    struct JobRow: Identifiable {
        let job: Job
        let monthlyIncome: Int
        let dailyHours: Int
        let isCurrent: Bool

        var id: Job { job }
    }

    var currentJob: Job? {
        player.job
    }

    var jobs: [JobRow] {
        Job.allCases.map { job in
            JobRow(
                job: job,
                monthlyIncome: GameCalculator(player: player).monthlyJobEarnings(for: job),
                dailyHours: job.dailyHours,
                isCurrent: currentJob == job
            )
        }
    }

    func switchToJob(_ job: Job) {
        guard currentJob != job else { return }
        gameService.switchJob(to: job)
    }
}
