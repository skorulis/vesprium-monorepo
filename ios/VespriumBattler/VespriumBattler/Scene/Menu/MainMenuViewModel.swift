// Created by Alex Skorulis on 13/4/2026.

import ASKCoordinator
import Foundation
import Knit
import KnitMacros

@Observable @MainActor final class MainMenuViewModel: CoordinatorViewModel {
    weak var coordinator: ASKCoordinator.Coordinator?

    @Resolvable<Resolver>
    init() {

    }
    
    func startBattle() {
        coordinator?.push(MainPath.battle)
    }
}
