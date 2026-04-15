//  Created by Alex Skorulis on 13/4/2026.

import ASKCore
import Foundation
import Knit

final class VespriumBattlerAssembly: AutoInitModuleAssembly {
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

        registerServices(container: container)
        registerStores(container: container)
        registerViewModels(container: container)
    }

    @MainActor
    private func registerServices(container: Container<TargetResolver>) {
        container.register(BattleService.self) { BattleService.make(resolver: $0) }
        container.register(EnemyService.self) { EnemyService.make(resolver: $0) }
        container.register(ShopService.self) { ShopService.make(resolver: $0) }
    }

    private func registerStores(container: Container<TargetResolver>) {
        container.register(MainStore.self) { MainStore.make(resolver: $0) }
            .inObjectScope(.container)
    }

    private func registerViewModels(container: Container<TargetResolver>) {
        container.register(MainPathRenderer.self) { MainPathRenderer(resolver: $0) }

        container.register(ContentViewModel.self) { ContentViewModel.make(resolver: $0) }
        container.register(GameViewModel.self) { GameViewModel.make(resolver: $0) }
        container.register(BattleViewModel.self) { BattleViewModel.make(resolver: $0) }
            .inObjectScope(.weak) // HACK TO FIX OBSERVATION ISSUES
        container.register(MainMenuViewModel.self) { MainMenuViewModel.make(resolver: $0) }
        container.register(ShopViewModel.self) { ShopViewModel.make(resolver: $0) }
        container.register(PlayerViewModel.self) { PlayerViewModel.make(resolver: $0) }
    }
}

extension VespriumBattlerAssembly {
    @MainActor static func testing() -> ScopedModuleAssembler<Resolver> {
        ScopedModuleAssembler<Resolver>([VespriumBattlerAssembly()])
    }
}
