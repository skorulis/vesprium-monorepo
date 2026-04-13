// Created by Alex Skorulis on 13/4/2026.

import Knit
import Foundation
import SwiftUI

struct BattleView {

    @State var viewModel: BattleViewModel

}

extension BattleView: View {

    var body: some View {
        Self._printChanges()
        return VStack {

        }
    }
}

extension BattleView {
    struct Model {
        var battle: Battle
    }
}

#Preview {
    let assembler = VespriumBattlerAssembly.testing()
    BattleView(viewModel: assembler.resolver.battleViewModel())
}
