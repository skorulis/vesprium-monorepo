import SwiftUI

struct CardDetailsView: View {
    let viewModel: CardDetailsViewModel

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            Section {
                Text(viewModel.cardTypeTitle)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(viewModel.accentColor)
            }

            Section("Summary") {
                ForEach(viewModel.summaryLines) { line in
                    LabeledContent(line.label, value: line.value)
                }
            }

            if !viewModel.jobIncomeLines.isEmpty {
                Section("Monthly income breakdown") {
                    ForEach(viewModel.jobIncomeLines) { line in
                        LabeledContent(line.label, value: line.value)
                    }
                    if let note = viewModel.jobSynergyNote {
                        Text(note)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            if !viewModel.activityBonusLines.isEmpty {
                Section("Yearly attribute effects") {
                    ForEach(viewModel.activityBonusLines) { line in
                        LabeledContent(line.label, value: line.value)
                    }
                }
            }

            if let description = viewModel.bodyEnhancementDescription {
                Section("Description") {
                    Text(description)
                }
            }

            if !viewModel.bodyEnhancementBonusLines.isEmpty {
                Section("Attribute effects") {
                    ForEach(viewModel.bodyEnhancementBonusLines) { line in
                        LabeledContent(line.label, value: line.value)
                    }
                }
            }
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}

#Preview("Job") {
    NavigationStack {
        CardDetailsView(
            viewModel: CardDetailsViewModel(
                card: .job(.farming),
                player: PlayerCharacter(dateOfBirth: .init(year: 10, month: .deep, day: 1)!)
            )
        )
    }
}

#Preview("Activity") {
    NavigationStack {
        CardDetailsView(
            viewModel: CardDetailsViewModel(
                card: .activity(.school),
                player: PlayerCharacter(dateOfBirth: .init(year: 10, month: .dusk, day: 1)!)
            )
        )
    }
}

#Preview("Body modification") {
    NavigationStack {
        CardDetailsView(
            viewModel: CardDetailsViewModel(
                card: .bodyEnhancement(.chlorophyllSkin),
                player: PlayerCharacter(dateOfBirth: .init(year: 10, month: .dusk, day: 1)!)
            )
        )
    }
}
