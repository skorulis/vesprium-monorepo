import ASKCore
import Knit
import KnitMacros
import Observation

@Observable
final class ContentViewModel {
    var title: String

    @Resolvable<Resolver>
    init() {
        title = "VespriumHackChoice"
    }

    func refreshTitle() {
        title = "VespriumHackChoice (updated)"
    }
}
