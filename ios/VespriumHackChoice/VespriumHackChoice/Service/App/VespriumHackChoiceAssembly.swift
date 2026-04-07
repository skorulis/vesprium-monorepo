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
    private func registerServices(container: Container<TargetResolver>) {}

    @MainActor
    private func registerStores(container: Container<TargetResolver>) {}

    @MainActor
    private func registerViewModels(container: Container<TargetResolver>) {
        container.register(ContentViewModel.self) { ContentViewModel.make(resolver: $0) }
    }
}

extension VespriumHackChoiceAssembly {
    @MainActor static func testing() -> ScopedModuleAssembler<Resolver> {
        ScopedModuleAssembler<Resolver>([VespriumHackChoiceAssembly()])
    }
}
