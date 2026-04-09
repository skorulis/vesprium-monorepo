import SwiftUI

struct MonthlyExpensesBreakdownView: View {
    let viewModel: MonthlyExpensesBreakdownViewModel

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            Section("Expenses") {
                LabeledContent("Food") {
                    Text(viewModel.breakdown.food, format: .number)
                        .monospacedDigit()
                }

                LabeledContent("Housing") {
                    Text(viewModel.breakdown.housing, format: .number)
                        .monospacedDigit()
                }

                LabeledContent("Total") {
                    Text(viewModel.breakdown.total, format: .number)
                        .monospacedDigit()
                        .bold()
                }
            }

        }
        .navigationTitle("Monthly expenses")
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

#Preview {
    NavigationStack {
        MonthlyExpensesBreakdownView(
            viewModel: VespriumHackChoiceAssembly.testing().resolver.monthlyExpensesBreakdownViewModel()
        )
    }
}
