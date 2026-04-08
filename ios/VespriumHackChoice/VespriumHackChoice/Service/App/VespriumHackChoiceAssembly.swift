import ASKCore
import Foundation
import Knit
import KnitMacros
import SwiftUI

// @knit internal
final class VespriumHackChoiceAssembly: AutoInitModuleAssembly {
    static var dependencies: [any Knit.ModuleAssembly.Type] { [] }
    typealias TargetResolver = Resolver

    private let purpose: IOCPurpose

    init() {
        self.purpose = .testing
    }

    init(purpose: IOCPurpose) {
        self.purpose = purpose
    }

    @MainActor func assemble(container: Container<TargetResolver>) {
        ASKCoreAssembly(purpose: purpose).assemble(container: container)

        container.register(MainPathRenderer.self) { MainPathRenderer(resolver: $0) }

        registerServices(container: container)
        registerStores(container: container)
        registerViewModels(container: container)
    }

    @MainActor
    private func registerServices(container: Container<TargetResolver>) {
        container.register(GameService.self) { GameService.make(resolver: $0) }
            .inObjectScope(.container)

        container.register(EventGenerator.self) { EventGenerator.make(resolver: $0) }

        container.register(CalculationsService.self) { CalculationsService.make(resolver: $0) }
    }

    @MainActor
    private func registerStores(container: Container<TargetResolver>) {
        container.register(MainStore.self) { MainStore.make(resolver: $0) }
            .inObjectScope(.container)
    }

    @MainActor
    private func registerViewModels(container: Container<TargetResolver>) {
        container.register(ContentViewModel.self) { ContentViewModel.make(resolver: $0) }
        container.register(MainMenuViewModel.self) { MainMenuViewModel.make(resolver: $0) }
        container.register(GameViewModel.self) { GameViewModel.make(resolver: $0) }
        container.register(PlayerCharacterWrapperViewModel.self) { PlayerCharacterWrapperViewModel.make(resolver: $0) }
        container.register(PlayerCardsViewModel.self) { PlayerCardsViewModel.make(resolver: $0) }
    }
}

extension VespriumHackChoiceAssembly {
    @MainActor static func testing() -> ScopedModuleAssembler<Resolver> {
        ScopedModuleAssembler<Resolver>([VespriumHackChoiceAssembly()])
    }
}
