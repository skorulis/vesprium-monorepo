import SwiftUI

struct JobView: View {
    @State var viewModel: JobViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("Current job") {
                    if let current = viewModel.currentJob {
                        LabeledContent("Role", value: current.name)
                    } else {
                        Text("Unemployed")
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Available jobs") {
                    ForEach(viewModel.jobs) { item in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .firstTextBaseline) {
                                Text(item.job.name)
                                    .font(.headline)
                                Spacer(minLength: 8)
                                Text("+\(item.monthlyIncome)")
                                    .font(.subheadline.monospacedDigit())
                                    .foregroundStyle(.secondary)
                            }

                            Text("\(item.dailyHours) hours/day")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            HStack {
                                if item.isCurrent {
                                    Text("Current")
                                        .font(.caption.weight(.semibold))
                                        .foregroundStyle(.green)
                                }
                                Spacer(minLength: 8)
                                Button(item.isCurrent ? "Selected" : "Switch") {
                                    viewModel.switchToJob(item.job)
                                }
                                .buttonStyle(.borderedProminent)
                                .disabled(item.isCurrent)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Jobs")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    JobView(viewModel: VespriumHackChoiceAssembly.testing().resolver.jobViewModel())
}
