import Observation
import SwiftUI

@MainActor
@Observable
final class CardDetailsViewModel {

    struct ValueLine: Identifiable, Sendable, Equatable {
        let id: String
        let label: String
        let value: String
    }

    let card: GameCard

    init(card: GameCard, player: PlayerCharacter) {
        self.card = card
        self.player = player
    }

    var title: String {
        card.name
    }

    var cardTypeTitle: String {
        switch card.type {
        case .job: return "Job"
        case .activity: return "Activity"
        case .bodyEnhancement: return "Body modification"
        }
    }

    var accentColor: Color {
        switch card.type {
        case .job: return .blue
        case .activity: return .purple
        case .bodyEnhancement: return .teal
        }
    }

    var summaryLines: [ValueLine] {
        switch card {
        case .job(let job):
            return [
                ValueLine(id: "job-hours", label: "Daily hours", value: "\(job.dailyHours)"),
                ValueLine(id: "job-income", label: "Monthly income", value: signedCoins(breakdown(for: job).total))
            ]
        case .activity(let activity):
            return [
                ValueLine(id: "activity-hours", label: "Daily hours", value: "\(activity.details.dailyHours)"),
                ValueLine(
                    id: "activity-cost",
                    label: "Monthly cost",
                    value: signedCoins(-activity.details.monthlyCost)
                )
            ]
        case .bodyEnhancement(let enhancement):
            return [
                ValueLine(id: "mod-cost", label: "Base cost", value: "\(enhancement.baseCost) coins")
            ]
        }
    }

    var jobIncomeLines: [ValueLine] {
        guard case .job(let job) = card else { return [] }
        let breakdown = breakdown(for: job)
        var lines = [ValueLine(id: "job-base", label: "Base", value: "+\(breakdown.baseIncome)")]
        lines.append(
            contentsOf: breakdown.contributions.map { contribution in
                ValueLine(
                    id: "job-\(contribution.attribute.rawValue)",
                    label: "\(contribution.attribute.name) (\(contribution.coefficient)x\(contribution.attributeValue))",
                    value: signedInt(contribution.amount)
                )
            }
        )
        lines.append(ValueLine(id: "job-subtotal", label: "Subtotal", value: signedInt(breakdown.preSynergyTotal)))
        if let synergyBonus = breakdown.synergyBonus {
            lines.append(ValueLine(id: "job-synergy", label: "Barometric ears bonus", value: signedInt(synergyBonus)))
        }
        lines.append(ValueLine(id: "job-total", label: "Total", value: signedInt(breakdown.total)))
        return lines
    }

    var activityBonusLines: [ValueLine] {
        guard case .activity(let activity) = card else { return [] }
        let sorted = activity.details.yearlyAttributeBonuses.sorted { $0.key.rawValue < $1.key.rawValue }
        guard !sorted.isEmpty else {
            return [ValueLine(id: "activity-none", label: "Yearly bonuses", value: "None")]
        }
        return sorted.map { attribute, value in
            ValueLine(
                id: "activity-\(attribute.rawValue)",
                label: "\(attribute.name) per year",
                value: signedInt(value)
            )
        }
    }

    var bodyEnhancementDescription: String? {
        guard case .bodyEnhancement(let enhancement) = card else { return nil }
        return enhancement.text
    }

    var bodyEnhancementBonusLines: [ValueLine] {
        guard case .bodyEnhancement(let enhancement) = card else { return [] }
        guard !enhancement.attributeBonuses.isEmpty else {
            return [ValueLine(id: "mod-none", label: "Attribute effects", value: "None")]
        }
        return enhancement.attributeBonuses.map { bonus in
            ValueLine(
                id: "mod-\(bonus.attribute.rawValue)",
                label: bonus.attribute.name,
                value: signedInt(bonus.value)
            )
        }
    }

    var jobSynergyNote: String? {
        guard case .job(let job) = card, job == .farming else { return nil }
        guard player.cards.hasEnhancement(.barometricEars) else { return nil }
        return "Farming income is increased by 50% from Barometric ears."
    }

    private let player: PlayerCharacter

    private func breakdown(for job: Job) -> GameCalculator.JobIncomeBreakdown {
        GameCalculator(player: player).monthlyJobIncomeBreakdown(for: job)
    }

    private func signedCoins(_ value: Int) -> String {
        "\(signedInt(value)) coins"
    }

    private func signedInt(_ value: Int) -> String {
        if value > 0 {
            return "+\(value)"
        }
        return "\(value)"
    }
}
