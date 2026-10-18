//
//  CartRatingView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов on 22.09.2026.
//

import SwiftUI

struct CartRatingView: View {
    let rating: Int
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<5, id: \.self) { index in
                Image(index < rating ? "starFilled" : "starEmpty")
                    .resizable()
                    .frame(width: 12, height: 12)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            String(
                localized: "Accessibility.cart.rating",
                defaultValue: "Rating \(rating) out of 5",
                comment: "Accessibility label describing the NFT rating."
            )
        )
    }
}

#Preview {
    CartRatingView(rating: 1)
        .padding()
    CartRatingView(rating: 3)
        .padding()
    CartRatingView(rating: 5)
        .padding()
}
