import SwiftUI

struct MainMenuView: View {
    @State var viewModel: MainMenuViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text("Vesprium Hack Choice")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)

            VStack(spacing: 12) {
                if !viewModel.isPristine {
                    Button {
                        viewModel.continueGame()
                    } label: {
                        Text("Continue")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }

                Group {
                    if viewModel.isPristine {
                        Button {
                            viewModel.startNewGame()
                        } label: {
                            Text("Start New Game")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    } else {
                        Button {
                            viewModel.startNewGame()
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
