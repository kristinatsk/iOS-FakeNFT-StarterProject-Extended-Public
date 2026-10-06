//
//  PaymentMethodView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов на 06.10.2026.
//

import Foundation
import SwiftUI

struct CryptoCurrencyCell: View {
    let currency: Currency
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 8) {
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


struct PaymentMethodView: View {
    private let currencies: [Currency]
    private let onPay: (Currency) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCurrencyID: String?

    init(
        currencies: [Currency],
        onPay: @escaping (Currency) -> Void = { _ in }
    ) {
        self.currencies = currencies
        self.onPay = onPay
    }

    private var selectedCurrency: Currency? {
        currencies.first { $0.id == selectedCurrencyID }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color.cartTextPrimary)
                }
                .accessibilityLabel("Payment.back")

                Spacer()

                Text("Payment.title")
                    .font(.bodyBold)
                    .foregroundStyle(Color.cartTextPrimary)

                Spacer()

                Color.clear
                    .frame(width: 20, height: 20)
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)

            ScrollView {
                LazyVGrid(
                    columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)],
                    spacing: 10
                ) {
                    ForEach(currencies) { currency in
                        CryptoCurrencyCell(
                            currency: currency,
                            isSelected: selectedCurrencyID == currency.id
                        ) {
                            selectedCurrencyID = currency.id
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 36)
            }

            VStack(alignment: .leading, spacing: 28) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Payment.agreement.description")
                        .font(.caption2)
                        .foregroundStyle(Color.cartTextPrimary)

                    Button(action: {}) {
                        Text("Payment.agreement.link")
                            .font(.caption2)
                            .foregroundStyle(.blue)
                    }
                    .buttonStyle(.plain)
                }

                Button {
                    guard let selectedCurrency else { return }
                    onPay(selectedCurrency)
                } label: {
                    Text("Payment.pay")
                        .font(.bodyBold)
                        .foregroundStyle(Color.cartButtonText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(selectedCurrency == nil ? Color.cartTextPrimary.opacity(0.25) : Color.cartButtonBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
                .disabled(selectedCurrency == nil)
            }
            .padding(.horizontal, 16)
            .padding(.top, 22)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.cartSeparator)
            .clipShape(.rect(topLeadingRadius: 12, topTrailingRadius: 12))
        }
        .background(Color.cartBackground.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PaymentMethodView(currencies: [
            Currency(id: "1", title: "Bitcoin", name: "BTC", image: URL(string: "https://example.com/bitcoin.png")!),
            Currency(id: "2", title: "Ethereum", name: "ETH", image: URL(string: "https://example.com/ethereum.png")!),
            Currency(id: "3", title: "Tether", name: "USDT", image: URL(string: "https://example.com/tether.png")!)
        ])
    }
}
