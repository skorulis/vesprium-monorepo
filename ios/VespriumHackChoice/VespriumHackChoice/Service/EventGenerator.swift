//  Created by Alexander Skorulis on 7/4/2026.

import Foundation
import Knit
import KnitMacros

struct EventGenerator {
    
    let mainStore: MainStore
    
    @Resolvable<Resolver>
    init(mainStore: MainStore) {
        self.mainStore = mainStore
    }
}
