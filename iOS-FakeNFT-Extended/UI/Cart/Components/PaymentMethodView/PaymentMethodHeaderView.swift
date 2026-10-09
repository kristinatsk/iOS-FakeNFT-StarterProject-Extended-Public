//
//  PaymentMethodHeaderView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов на 06.10.2026.
//

import SwiftUI

struct PaymentMethodHeaderView: View {
    let onBack: () -> Void

    var body: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: SystemImageName.chevronLeft)
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
    }
}
