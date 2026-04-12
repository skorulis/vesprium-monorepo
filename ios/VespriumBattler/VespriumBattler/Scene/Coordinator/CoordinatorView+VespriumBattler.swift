// Created by Alex Skorulis on 13/4/2026.

import Foundation

import ASKCoordinator
import Knit
import SwiftUI

extension CoordinatorView {
    func withRenderers(resolver: Resolver) -> Self {
        self.with(renderer: resolver.mainPathRenderer())
    }
}
