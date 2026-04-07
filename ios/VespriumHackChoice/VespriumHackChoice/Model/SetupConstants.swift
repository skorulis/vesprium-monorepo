//  Created by Alex Skorulis on 7/4/2026.

import Foundation
import BioStats

enum SetupConstants {
    static let gameStartTime = VespriumDate(year: 1250, month: .thaw, day: 1)!

    static let defaultPlayerDOB = Self.gameStartTime.adding(years: -25)
}
