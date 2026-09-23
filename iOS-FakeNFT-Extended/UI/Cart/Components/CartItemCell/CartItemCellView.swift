//
//  CartItemCellView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов on 22.09.2026.
//

import SwiftUI

struct CartItemCellView: View {
    let model: CartItemCellModel
    @Environment(\.nftImageResolver) private var imageResolver
    
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
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
                    Text(NSLocalizedString("cart.price", comment: ""))
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
        imageResolver(model.imageURL)
            .scaledToFill()
            .frame(width: 108, height: 108)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var deleteButton: some View {
        Button {
            model.onDelete()
        } label: {
            Image("trash")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Удалить из корзины")
    }
    
    private var priceString: String {
        String(format: "%.2f ETH", model.price)
    }
}

#Preview {
    CartItemCellView(model: CartItemCellModel(
        id: "1",
        name: "April",
        imageURL: URL(string: "https://example.com/april.png"),
        rating: 3,
        price: 1.78,
        onDelete: { print("delete tapped") }
    ))
    .environment(\.nftImageResolver) { AnyView(MockNFTImage(url: $0)) }
    .background(Color.cartBackground)
}
