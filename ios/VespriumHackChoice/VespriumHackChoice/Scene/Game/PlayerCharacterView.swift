import BioStats
import SwiftUI

/// Presents the full player profile: vitals, finance, daily time allocation, birth date, and attribute scores.
struct PlayerCharacterView: View {
    let player: PlayerCharacter
    let currentGameDate: VespriumDate
    let monthlyBalanceChange: Int

    var body: some View {
        List {
            Section("Vitals") {
                LabeledContent("Age") {
                    Text(ageLabel)
                        .monospacedDigit()
                }
                if let job = player.job {
                    LabeledContent("Job", value: job.name)
                }
            }

            Section("Finance") {
                LabeledContent("Current money") {
                    Text(player.money, format: .number)
                        .monospacedDigit()
                }
                LabeledContent("Monthly change") {
                    Text(monthlyBalanceChangeLabel)
                        .monospacedDigit()
                }
            }

            Section("Daily time") {
                DailyTimeAllocationView(playerCards: player.cards)
                    .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 14, trailing: 16))
            }

            Section("Birth") {
                LabeledContent("Date of birth", value: formattedDate(player.dateOfBirth))
            }

            Section("Attributes") {
                ForEach(Attribute.allCases, id: \.self) { attribute in
                    LabeledContent(attribute.name) {
                        let value = player.attributes[attribute]
                        Text("\(value)")
                            .monospacedDigit()
                    }
                }
            }
        }
    }

    private var ageLabel: String {
        let years = player.ageInFullYears(on: currentGameDate)
        let months = player.ageExtraMonths(on: currentGameDate)
        return "\(years) years, \(months) months"
    }

    /// Net cash flow from jobs and activities for the upcoming month (matches `GameService` month ticks).
    private var monthlyBalanceChangeLabel: String {
        let change = monthlyBalanceChange
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
}

#Preview {
    NavigationStack {
        PlayerCharacterView(
            player: playerCharacterPreview,
            currentGameDate: playerCharacterPreviewDate,
            monthlyBalanceChange: GameCalculator(player: playerCharacterPreview).monthlyBalanceChange()
        )
        .navigationTitle("Player")
    }
}

private let playerCharacterPreviewDate = VespriumDate(year: 5, month: .ember, day: 14)!

private let playerCharacterPreview: PlayerCharacter = {
    let birth = VespriumDate(year: 1, month: .thaw, day: 1)!
    var attrs = AttributeValues()
    attrs[.strength] = 10
    attrs[.intelligence] = 7
    var player = PlayerCharacter(
        attributes: attrs,
        money: 1_250,
        dateOfBirth: birth
    )
    player.cards = PlayerCards(job: .farming, addedOn: playerCharacterPreviewDate)
    return player
}()
