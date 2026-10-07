//
//  SuccessPaymentView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов на 07.10.2026.
//

import SwiftUI

struct SuccessPaymentView: View {
    let onBackToCart: () -> Void

    var body: some View {
        VStack {
            Spacer()
            Image(.successPaymentPlaceholder)
                .frame(width: 278, height: 278)
            Text("Success.payment.title")
                .font(.headline3)
                .foregroundStyle(Color.cartTextPrimary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.cartBackground)

        Spacer()

        Button {
            onBackToCart()
        } label: {
            Text("Success.payment.back")
                .font(.bodyBold)
                .foregroundStyle(Color.cartButtonText)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color.cartButtonBackground)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .padding(16)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SuccessPaymentView(onBackToCart: { })
}
