//  Created by Alex Skorulis on 8/4/2026.

import Foundation
import Knit
import KnitMacros

struct CalculationsService {

    let mainStore: MainStore

    @Resolvable<Resolver>
    init(mainStore: MainStore) {
        self.mainStore = mainStore
    }
    
}
