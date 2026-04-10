import SwiftUI

struct ShopView: View {
    @State var viewModel: ShopViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.shopItems.isEmpty {
                    ContentUnavailableView(
                        "No enhancements available",
                        systemImage: "cart",
                        description: Text("Advance to a new year to refresh the shop.")
                    )
                } else {
                    List {
                        Section("Bio enhancements") {
                            ForEach(viewModel.shopItems) { item in
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(alignment: .firstTextBaseline) {
                                        Text(item.enhancement.name)
                                            .font(.headline)
                                        Spacer(minLength: 8)
                                        Text(item.price, format: .number)
                                            .font(.subheadline.monospacedDigit())
                                            .foregroundStyle(.secondary)
                                    }
                                    Text(item.enhancement.text)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)

                                    HStack {
                                        if item.isOwned {
                                            Text("Owned")
                                                .font(.caption.weight(.semibold))
                                                .foregroundStyle(.green)
                                        } else if item.canAfford == false {
                                            Text("Not enough money")
                                                .font(.caption.weight(.semibold))
                                                .foregroundStyle(.orange)
                                        }
                                        Spacer(minLength: 8)
                                        Button("Buy") {
                                            viewModel.purchase(item.enhancement)
                                        }
                                        .buttonStyle(.borderedProminent)
                                        .disabled(!item.canPurchase)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Shop")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .safeAreaInset(edge: .top) {
                VStack(spacing: 4) {
                    HStack {
                        Text("Money")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                        Spacer(minLength: 8)
                        Text(viewModel.player.money, format: .number)
                            .font(.headline.monospacedDigit())
                    }
                    if let statusMessage = viewModel.statusMessage {
                        Text(statusMessage)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial)
            }
        }
    }
}
