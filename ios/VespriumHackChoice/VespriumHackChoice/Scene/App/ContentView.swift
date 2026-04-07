import SwiftUI

struct ContentView: View {
    @Bindable var model: ContentViewModel

    var body: some View {
        VStack(spacing: 16) {
            Text(model.title)
                .font(.title2)
            Button("Refresh") {
                model.refreshTitle()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
