import BioStats
import SwiftUI

/// Presents the full player profile: vitals, birth date, resources, profession, and attribute scores.
struct PlayerCharacterView: View {
    let player: PlayerCharacter
    let currentGameDate: VespriumDate

    var body: some View {
        List {
            Section("Vitals") {
                LabeledContent("Age") {
                    Text("\(player.ageInFullYears(on: currentGameDate)) years")
                        .monospacedDigit()
                }
                LabeledContent("Money") {
                    Text(player.money, format: .number)
                        .monospacedDigit()
                }
                LabeledContent("Job", value: jobLabel(player.job))
            }

            Section("Birth") {
                LabeledContent("Date of birth", value: formattedDate(player.dateOfBirth))
            }

            Section("Attributes") {
                ForEach(Attribute.allCases, id: \.self) { attribute in
                    LabeledContent(attributeLabel(attribute)) {
                        let value = player.attributes[attribute]
                        Text("\(value)")
                            .monospacedDigit()
                    }
                }
            }
        }
    }

    private func formattedDate(_ date: VespriumDate) -> String {
        "\(date.year) \(date.month.displayName) \(date.day)"
    }

    private func jobLabel(_ job: Job) -> String {
        switch job {
        case .farming:
            "Farming"
        }
    }

    private func attributeLabel(_ attribute: Attribute) -> String {
        switch attribute {
        case .strength:
            "Strength"
        case .agility:
            "Agility"
        case .intelligence:
            "Intelligence"
        case .vitality:
            "Vitality"
        case .charisma:
            "Charisma"
        case .stability:
            "Stability"
        }
    }
}

#Preview {
    let birth = VespriumDate(year: 1, month: .thaw, day: 1)!
    var attrs = AttributeValues()
    attrs[.strength] = 10
    attrs[.intelligence] = 7
    let player = PlayerCharacter(
        attributes: attrs,
        money: 1_250,
        job: .farming,
        dateOfBirth: birth
    )
    let now = VespriumDate(year: 5, month: .ember, day: 14)!
    return NavigationStack {
        PlayerCharacterView(player: player, currentGameDate: now)
            .navigationTitle("Player")
    }
}
