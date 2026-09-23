//
//  CartEmptyView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов on 22.09.2026.
//

import SwiftUI

struct CartEmptyView: View {
    var body: some View {
        VStack {
            Spacer()
            Text(NSLocalizedString("cart.empty", comment: ""))
                .font(.bodyBold)
                .foregroundStyle(Color.cartTextPrimary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.cartBackground)
    }
}

#Preview {
    CartEmptyView()
}
