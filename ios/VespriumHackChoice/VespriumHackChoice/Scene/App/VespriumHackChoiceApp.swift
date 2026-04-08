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
                ContentView(viewModel: assembler.resolver.contentViewModel())
                    .environment(\.resolver, assembler.resolver)
            }
        }
    }
}

private extension ProcessInfo {
    static var isRunningTests: Bool {
        processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
}
