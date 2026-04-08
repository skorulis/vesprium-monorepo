import BioStats
import SwiftUI

struct YearEndReviewView: View {
    let review: YearEndReview
    let onContinue: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 16) {
                Text("Year \(review.year)")
                    .font(.title2.weight(.semibold))
                Text("Net money this year: \(review.totals.moneyNetChange, format: .number)")
                    .font(.body.monospacedDigit())
                if review.totals.attributeIncreases.isEmpty {
                    Text("No stat increases from activities this year.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    Text("Stat increases")
                        .font(.subheadline.weight(.medium))
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(sortedAttributes(review.totals.attributeIncreases), id: \.self) { attribute in
                            if let delta = review.totals.attributeIncreases[attribute], delta != 0 {
                                Text("\(attribute.name): +\(delta)")
                                    .font(.body.monospacedDigit())
                            }
                        }
                    }
                }
                Button("Continue") {
                    onContinue()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
            }
            .padding(24)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.background)
            }
            .padding(20)
        }
    }

    private func sortedAttributes(_ map: [Attribute: Int]) -> [Attribute] {
        Attribute.allCases.filter { map[$0] != nil && map[$0] != 0 }
    }
}
