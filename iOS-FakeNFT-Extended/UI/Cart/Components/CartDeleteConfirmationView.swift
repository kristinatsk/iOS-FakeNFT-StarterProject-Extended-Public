//
//  CartDeleteConfirmationView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов на 24.09.2026.
//

import SwiftUI

struct CartDeleteConfirmationView: View {
    let item: CartItemCellModel
    let onDelete: () -> Void
    let onCancel: () -> Void
    let isDeleting: Bool
    
    @Environment(\.nftImageResolver) private var imageResolver
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                nftImage
                    .frame(width: 108, height: 108)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                Text(NSLocalizedString("cart.delete.confirm", comment: ""))
                    .font(.bodyRegular)
                    .foregroundStyle(Color.cartTextPrimary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)
                    .frame(maxWidth: 310)
            }
            HStack(spacing: 8) {
                Button(action: onDelete) {
                    if isDeleting {
                        ProgressView()
                            .tint(Color.cartDeleteText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.cartButtonBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } else {
                        Text(NSLocalizedString("cart.delete.remove", comment: ""))
                            .font(.bodyRegular)
                            .foregroundStyle(Color.cartDeleteText)
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.cartButtonBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .disabled(isDeleting)
                .buttonStyle(.plain)
                
                Button(action: onCancel) {
                    Text(NSLocalizedString("cart.delete.cancel", comment: ""))
                        .font(.bodyRegular)
                        .foregroundStyle(Color.cartButtonText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color.cartButtonBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 56)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private var nftImage: some View {
        if item.isLoading {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.cartTextPrimary.opacity(0.08))
        } else {
            imageResolver(item.imageURL)
                .scaledToFill()
        }
    }
}
