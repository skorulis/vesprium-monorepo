// Created by Alex Skorulis on 13/4/2026.

import Foundation
import Knit
import SwiftUI

struct MainMenuView {
    @State var viewModel: MainMenuViewModel
}

extension MainMenuView: View {

    var body: some View {
        VStack {
            Button(action: viewModel.startGame) {
                Text("Start")
            }
        }
    }
}

#Preview {
    let assembler = VespriumBattlerAssembly.testing()
    MainMenuView(viewModel: assembler.resolver.mainMenuViewModel())
}
