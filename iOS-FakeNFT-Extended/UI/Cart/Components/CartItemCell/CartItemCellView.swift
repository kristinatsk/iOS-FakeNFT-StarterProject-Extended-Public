//
//  CartItemCellView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов на 22.09.2026.
//

import ProgressHUD
import SwiftUI

struct CartItemCellView: View {
    let model: CartItemCellModel
    let onDeleteRequest: (CartItemCellModel) -> Void
    @Environment(\.nftImageResolver) private var imageResolver

    var body: some View {
        HStack(spacing: 20) {
            nftImage
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(model.name)
                        .font(.bodyBold)
                        .foregroundStyle(Color.cartTextPrimary)
                        .lineLimit(1)
                        .truncationMode(.tail)

                    CartRatingView(rating: model.rating)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("cart.price")
                        .font(.caption2)

                    Text(priceString)
                        .font(.bodyBold)
                        .foregroundStyle(Color.cartTextPrimary)
                }
            }

            Spacer(minLength: 8)
            deleteButton
        }
        .padding(16)
        .background(Color.cartBackground)
    }

    private var nftImage: some View {
        Group {
            if model.isLoading {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.cartTextPrimary.opacity(0.08))
                    .onAppear {
                        ProgressHUD.animate(nil, interaction: false)
                    }
                    .onDisappear {
                        ProgressHUD.dismiss()
                    }
            } else {
                imageResolver(model.imageURL)
            }
        }
        .scaledToFill()
        .frame(width: 108, height: 108)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var priceString: String {
        String(format: "%.2f ETH", model.price)
    }

    private var deleteButton: some View {
        Button {
            onDeleteRequest(model)
        } label: {
            Image(.trash)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text("Accessibility.cart.remove"))
    }
}

#Preview("Network image") {
    CartItemCellView(
        model: CartItemCellModel(
            id: "1",
            name: "April",
            imageURL: URL(string: "https://example.com/april.png"),
            rating: 3,
            price: 1.78
        ),
        onDeleteRequest: { _ in }
    )
    .background(Color.cartBackground)
}

#Preview("Mock image") {
    CartItemCellView(
        model: CartItemCellModel(
            id: "1",
            name: "April",
            imageURL: URL(string: "https://example.com/april.png"),
            rating: 3,
            price: 1.78
        ),
        onDeleteRequest: { _ in }
    )
    .environment(\.nftImageResolver) { AnyView(MockNFTImage(url: $0)) }
    .background(Color.cartBackground)
}
