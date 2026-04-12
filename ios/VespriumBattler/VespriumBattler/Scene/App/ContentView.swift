//  Created by Alex Skorulis on 13/4/2026.

import ASKCoordinator
import Knit
import SwiftUI

struct ContentView: View {

    @State var viewModel: ContentViewModel
    @Environment(\.resolver) private var resolver

    var body: some View {
        CoordinatorView(coordinator: Coordinator(root: MainPath.mainMenu))
            .withRenderers(resolver: resolver!)
    }
}

#Preview {
    let assembler = VespriumBattlerAssembly.testing()
    ContentView(viewModel: assembler.resolver.contentViewModel())
}
