import ASKCoordinator
import SwiftUI

struct ContentView: View {
    @State var model: ContentViewModel
    @Environment(\.resolver) private var resolver

    var body: some View {
        CoordinatorView(coordinator: Coordinator(root: MainPath.game))
            .withRenderers(resolver: resolver!)
    }
}
