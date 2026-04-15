// Created by Alexander Skorulis on 15/4/2026.

import BioEnhancements
import BioStats
import Foundation
import SwiftUI

// MARK: - Memory footprint

@MainActor struct ShopItemBonusesView {
    let item: ShopItem
}

// MARK: - Rendering

extension ShopItemBonusesView: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(item.attributeBonusText, id: \.self) { text in
                Text(text)
                    .font(.caption)
            }

            ForEach(item.derivedAttributeBoostsText, id: \.self) { text in
                Text(text)
                    .font(.caption)
            }

            ForEach(item.strainIncreaseText, id: \.self) { text in
                Text(text)
                    .font(.caption)
            }
        }
    }
}

// MARK: - Previews

#Preview {
    ShopItemBonusesView(item: BioEnhancement.muscleEnergyImplants)
}

