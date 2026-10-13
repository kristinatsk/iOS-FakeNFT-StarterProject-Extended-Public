//
//  CartTotalView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов on 22.09.2026.
//

import SwiftUI

struct CartTotalView: View {
    let model: CartTotalViewModel
    
    var body: some View {
        HStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 4) {
                Text(
                    String(
                        localized: "cart.count.format",
                        defaultValue: "\(model.count) NFTs",
                        comment: "Number of NFTs in the cart."
                    )
                )
                    .font(.caption1)
                    .foregroundStyle(Color.cartTextPrimary)
                
                Text(totalString)
                    .font(.bodyBold)
                    .foregroundStyle(Color.cartAccentGreen)
            }
            
            payButton
        }
        .frame(height: 76)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .background(Color.cartSeparator)
        .clipShape(.rect(topLeadingRadius: 12, topTrailingRadius: 12))
    }
    
    private var payButton: some View {
        Button {
            model.onPay()
        } label: {
            Text("cart.pay")
                .font(.bodyBold)
                .foregroundStyle(Color.cartButtonText)
                .frame(width: 240, height: 44)
                .background(Color.cartButtonBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
    
    private var totalString: String {
        String(format: "%.2f ETH", model.totalPrice)
    }
}

#Preview {
    CartTotalView(model: CartTotalViewModel(
        count: 3,
        totalPrice: 5.34,
        onPay: { print("pay tapped") }
    ))
}
