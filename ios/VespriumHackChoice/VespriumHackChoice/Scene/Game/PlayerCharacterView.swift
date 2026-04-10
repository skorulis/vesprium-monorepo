import BioEnhancements
import BioStats
import SwiftUI

/// Presents the full player profile: vitals, finance, daily time allocation, birth date, and attribute scores.
struct PlayerCharacterView: View {
    @State var viewModel: PlayerCharacterViewModel
    var model: Model { viewModel.model }

    var body: some View {
        List {
            Section("Vitals") {
                LabeledContent("Age") {
                    Text(ageLabel)
                        .monospacedDigit()
                }
                LabeledContent("Weakness chance") {
                    Text(weaknessChanceLabel)
                        .monospacedDigit()
                }
                if let job = model.player.job {
                    LabeledContent("Job", value: job.name)
                }
            }

            Section("Finance") {
                LabeledContent("Current money") {
                    Text(model.player.money, format: .number)
                        .monospacedDigit()
                }
                LabeledContent("Job income") {
                    if let income = model.monthlyJobIncome {
                        Text(income, format: .number)
                            .monospacedDigit()
                    } else {
                        Text("—")
                            .foregroundStyle(.secondary)
                    }
                }
                LabeledContent("Monthly expenses") {
                    HStack(spacing: 8) {
                        Text(model.monthlyLivingExpensesBreakdown.total, format: .number)
                            .monospacedDigit()
                        Button {
                            viewModel.presentMonthlyExpensesBreakdown()
                        } label: {
                            Image(systemName: "info.circle")
                        }
                        .buttonStyle(.borderless)
                        .accessibilityLabel("Monthly expenses breakdown")
                    }
                }
                LabeledContent("Monthly change") {
                    Text(monthlyBalanceChangeLabel)
                        .monospacedDigit()
                }
            }

            Section("Daily time") {
                DailyTimeAllocationView(playerCards: model.player.cards)
                    .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 14, trailing: 16))
            }

            Section("Strain") {
                LabeledContent("Physical") {
                    Text(model.strain.physical, format: .number)
                        .monospacedDigit()
                }
                LabeledContent("Mental") {
                    Text(model.strain.mental, format: .number)
                        .monospacedDigit()
                }
            }

            Section("Birth") {
                LabeledContent("Date of birth", value: formattedDate(model.player.dateOfBirth))
            }

            Section("Attributes") {
                ForEach(Attribute.allCases, id: \.self) { attribute in
                    LabeledContent(attribute.name) {
                        let base = model.player.attributes[attribute]
                        let effective = model.player.effectiveAttributes[attribute]
                        let delta = effective - base
                        Text("\(effective)")
                            .monospacedDigit()
                            .foregroundStyle(delta > 0 ? Color.green : delta < 0 ? Color.red : Color.primary)
                    }
                }
            }
        }
    }

    private var ageLabel: String {
        let years = model.player.ageInFullYears(on: model.gameState.currentGameDate)
        let months = model.player.ageExtraMonths(on: model.gameState.currentGameDate)
        return "\(years) years, \(months) months"
    }

    /// Net cash flow after jobs, cards, and living expenses (matches `GameService` month ticks).
    private var monthlyBalanceChangeLabel: String {
        let change = model.monthlyBalanceChange
        if change > 0 {
            return "+\(change)"
        } else if change < 0 {
            return "\(change)"
        } else {
            return "0"
        }
    }

    private func formattedDate(_ date: VespriumDate) -> String {
        "\(date.year) \(date.month.displayName) \(date.day)"
    }

    private var weaknessChanceLabel: String {
        let chance = GameCalculator(player: model.player).weaknessChance(on: model.gameState.currentGameDate)
        return "\(chance)%"
    }
}

extension PlayerCharacterView {
    struct Model {
        var gameState: GameState
        var player: PlayerCharacter

        var monthlyBalanceChange: Int {
            GameCalculator(player: player).monthlyBalanceChange()
        }

        var monthlyLivingExpensesBreakdown: GameCalculator.MonthlyLivingExpensesBreakdown {
            GameCalculator(player: player).monthlyLivingExpensesBreakdown()
        }

        /// Monthly earnings from the equipped job (including attribute bonuses), or `nil` if unemployed.
        var monthlyJobIncome: Int? {
            guard let job = player.job else { return nil }
            return GameCalculator(player: player).monthlyJobEarnings(for: job)
        }

        var strain: Strain {
            GameCalculator(player: player).calculateStrain()
        }
    }
}

#Preview {
    NavigationStack {
        PlayerCharacterView(viewModel: VespriumHackChoiceAssembly.testing().resolver.playerCharacterViewModel())
        .navigationTitle("Player")
    }
}
