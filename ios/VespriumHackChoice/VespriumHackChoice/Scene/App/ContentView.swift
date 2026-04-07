import ASKCoordinator
import SwiftUI

struct ContentView: View {
    @State var model: ContentViewModel
    @Environment(\.resolver) private var resolver

    @State private var gameCoordinator = Coordinator(root: MainPath.game)
    @State private var characterCoordinator = Coordinator(root: MainPath.character)

    var body: some View {
        TabView {
            CoordinatorView(coordinator: gameCoordinator)
                .withRenderers(resolver: resolver!)
                .tabItem {
                    Label("Game", systemImage: "gamecontroller")
                }

            CoordinatorView(coordinator: characterCoordinator)
                .withRenderers(resolver: resolver!)
                .tabItem {
                    Label("Character", systemImage: "person.crop.circle")
                }
        }
    }
}
