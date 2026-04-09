//  Created by Alex Skorulis on 9/4/2026.

import BioStats
import Foundation

/// One row in the on-screen month log (income plus optional event / resolution).
struct MonthSummary: Codable, Sendable, Equatable {
    var date: VespriumDate
    var moneyDelta: Int
    var eventHeadline: String?
    var choiceSummary: String?
}
