import BioEnhancements
import Combine
import Knit
import KnitMacros
import Observation

@MainActor
@Observable
final class ShopViewModel {
    let gameService: GameService
    private let mainStore: MainStore

    var gameState: GameState
    var player: PlayerCharacter
    var statusMessage: String?

    private var cancellables: Set<AnyCancellable> = []

    @Resolvable<Resolver>
    init(gameService: GameService, mainStore: MainStore) {
        self.gameService = gameService
        self.mainStore = mainStore
        self.gameState = mainStore.gameState
        self.player = mainStore.player
        self.statusMessage = nil

        mainStore.$gameState.sink { [unowned self] in
            self.gameState = $0
        }
        .store(in: &cancellables)

        mainStore.$player.sink { [unowned self] in
            self.player = $0
        }
        .store(in: &cancellables)
    }
}

extension ShopViewModel {
    struct ItemRow: Identifiable {
        let enhancement: BioEnhancement
        let price: Int
        let isOwned: Bool
        let canAfford: Bool

        var id: String { enhancement.rawValue }
        var canPurchase: Bool { !isOwned && canAfford }
    }

    var shopItems: [ItemRow] {
        gameState.shopEnhancements.map { enhancement in
            let owned = player.cards.hasEnhancement(enhancement)
            return ItemRow(
                enhancement: enhancement,
                price: enhancement.baseCost,
                isOwned: owned,
                canAfford: player.money >= enhancement.baseCost
            )
        }
    }

    func purchase(_ enhancement: BioEnhancement) {
        switch gameService.purchaseShopEnhancement(enhancement) {
        case .purchased:
            statusMessage = "Purchased \(enhancement.name)."
        case .alreadyOwned:
            statusMessage = "\(enhancement.name) is already installed."
        case .insufficientFunds:
            statusMessage = "Not enough money for \(enhancement.name)."
        }
    }
}
