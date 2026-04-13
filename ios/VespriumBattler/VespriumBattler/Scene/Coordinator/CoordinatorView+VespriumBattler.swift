// Created by Alex Skorulis on 13/4/2026.

import Foundation

import ASKCoordinator
import Knit
import SwiftUI

extension CoordinatorView {
    func withRenderers(resolver: Resolver) -> Self {
        self.with(renderer: resolver.mainPathRenderer())
            .with(overlay: .basicDialog) { view, _ in
                AnyView(BasicOverlayDialog { Card { view } })
            }
    }
}

private struct Card<Content: View>: View {

    let content: () -> Content

    var body: some View {
        ZStack {
            content()
        }
        .padding(24)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.background)
        }
    }
}
