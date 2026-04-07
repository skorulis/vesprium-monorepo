import ASKCoordinator
import SwiftUI

struct ContentView: View {
    @State var model: ContentViewModel
    @Environment(\.resolver) private var resolver

    var body: some View {
        TabView {
            CoordinatorView(coordinator: Coordinator(root: MainPath.game))
                .withRenderers(resolver: resolver!)
                .tabItem {
                    Label("Game", systemImage: "gamecontroller")
                }

            CoordinatorView(coordinator: Coordinator(root: MainPath.character))
                .withRenderers(resolver: resolver!)
                .tabItem {
                    Label("Character", systemImage: "person.crop.circle")
                }

            CoordinatorView(coordinator: Coordinator(root: MainPath.cards))
                .withRenderers(resolver: resolver!)
                .tabItem {
                    Label("Cards", systemImage: "rectangle.stack")
                }
        }
    }
}
