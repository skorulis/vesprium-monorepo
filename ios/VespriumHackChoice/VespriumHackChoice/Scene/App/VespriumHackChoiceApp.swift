import ASKCoordinator
import ASKCore
import Knit
import SwiftUI

@main
struct VespriumHackChoiceApp: App {
    private let assembler: ScopedModuleAssembler<Resolver> = {
        let assembler = ScopedModuleAssembler<Resolver>(
            [
                VespriumHackChoiceAssembly(purpose: .normal)
            ]
        )
        return assembler
    }()

    var body: some Scene {
        WindowGroup {
            if ProcessInfo.isRunningTests {
                Color.clear
            } else {
                CoordinatorView(coordinator: Coordinator(root: MainPath.content))
                    .withRenderers(resolver: assembler.resolver)
                    .environment(\.resolver, assembler.resolver as Resolver?)
            }
        }
    }
}

private extension ProcessInfo {
    static var isRunningTests: Bool {
        processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
}
