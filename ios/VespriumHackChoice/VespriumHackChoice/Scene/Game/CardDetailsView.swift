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

            Section("Actions") {
                if viewModel.canRemove {
                    Button("Remove card", role: .destructive) {
                        viewModel.remove()
                        dismiss()
                    }
                } else {
                    Label("Locked", systemImage: "lock.fill")
                        .foregroundStyle(.secondary)
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
        let assembly = VespriumHackChoiceAssembly.testing()
        CardDetailsView(
            viewModel: assembly.resolver.cardDetailsViewModel(card: .job(.farming))
        )
    }
}
