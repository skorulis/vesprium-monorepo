import BioStats
import SwiftUI

/// Horizontal bar showing how many hours per day are busy (from cards) versus resting.
struct DailyTimeAllocationView: View {
    let playerCards: PlayerCards

    var body: some View {
        let busy = playerCards.totalDailyHours
        let hoursPerDay = VespriumCalendar.hoursPerDay
        let resting = max(0, hoursPerDay - busy)
        let busyFraction = min(1, CGFloat(busy) / CGFloat(hoursPerDay))

        VStack(alignment: .leading, spacing: 10) {
            GeometryReader { geo in
                let width = geo.size.width
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Self.busyFill)
                        .frame(width: width * busyFraction)
                    Rectangle()
                        .fill(Self.restingFill)
                        .frame(width: width * (1 - busyFraction))
                }
                .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            }
            .frame(height: 18)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Daily time")
            .accessibilityValue(
                "\(busy) hours busy, \(resting) hours resting, out of \(hoursPerDay) hours"
            )

            HStack(alignment: .top, spacing: 16) {
                sectionLabel(title: "Busy", hours: busy, alignment: .leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                sectionLabel(title: "Resting", hours: resting, alignment: .trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }

    private func sectionLabel(title: String, hours: Int, alignment: HorizontalAlignment) -> some View {
        VStack(alignment: alignment, spacing: 2) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
            Text("\(hours)h")
                .font(.caption.monospacedDigit())
                .foregroundStyle(.secondary)
        }
        .minimumScaleFactor(0.85)
    }

    private static let busyFill = Color.accentColor.opacity(0.85)
    private static let restingFill = Color.secondary.opacity(0.28)
}

#Preview("With job") {
    DailyTimeAllocationView(playerCards: PlayerCards(job: .farming))
        .padding()
}

#Preview("No cards") {
    DailyTimeAllocationView(playerCards: PlayerCards(job: nil))
        .padding()
}
