//  Created by Alex Skorulis on 13/4/2026.

import ASKCoordinator
import Knit
import SwiftUI

struct ContentView: View {

    @State var viewModel: ContentViewModel

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    let assembler = VespriumBattlerAssembly.testing()
    ContentView(viewModel: assembler.resolver.contentViewModel())
}
