import SwiftUI

struct MainMenuView: View {
    @ObservedObject var mainStore: MainStore

    var body: some View {
        VStack(spacing: 24) {
            Text("Vesprium Hack Choice")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

            VStack(spacing: 12) {
                if !mainStore.isPristine {
                    Button {
                        mainStore.showMainMenu = false
                    } label: {
                        Text("Continue")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }

                Group {
                    if mainStore.isPristine {
                        Button {
                            mainStore.resetToNewGame()
                            mainStore.showMainMenu = false
                        } label: {
                            Text("Start New Game")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    } else {
                        Button {
                            mainStore.resetToNewGame()
                            mainStore.showMainMenu = false
                        } label: {
                            Text("Start New Game")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
