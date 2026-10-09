//
//  CryptoCurrencyCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов на 06.10.2026.
//

import SwiftUI

struct CryptoCurrencyCell: View {
    @Environment(\.nftImageResolver) private var imageResolver

    let currency: Currency
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 8) {
                imageResolver(currency.imageURL)
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 9))
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 2) {
                    Text(currency.title)
                        .font(.caption2)
                        .foregroundStyle(Color.cartTextPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Text(currency.name)
                        .font(.caption2)
                        .foregroundStyle(Color.cartAccentGreen)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 46, alignment: .leading)
            .padding(.horizontal, 12)
            .background(Color.cartSeparator)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(
                        isSelected ? Color.cartTextPrimary : .clear,
                        lineWidth: 1
                    )
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(String(localized: "Payment.currency.accessibility \(currency.title), \(currency.name)"))
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}
