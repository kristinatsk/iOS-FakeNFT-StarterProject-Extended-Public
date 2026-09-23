//
//  CartView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов на 22.09.2026.
//

import SwiftUI

@MainActor
struct CartView: View {
    @StateObject private var viewModel: CartViewModel
    
    init(viewModel: CartViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isEmpty {
                CartEmptyView()
            } else {
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        Spacer()
                        sortButton
                    }
                    .padding(15)
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(Array(viewModel.items.enumerated()), id: \.element.id) { index, item in
                                VStack(spacing: 0) {
                                    CartItemCellView(model: item)
                                    if index < viewModel.items.count - 1 {
                                        Color.cartSeparator.frame(height: 0.5)
                                    }
                                }
                            }
                        }
                    }
                }
                
                CartTotalView(model: CartTotalViewModel(
                    count: viewModel.items.count,
                    totalPrice: viewModel.totalPrice,
                    onPay: {
                        // TODO: в задаче 3 модуля добавить логику оплаты
                    }
                ))
            }
            
            
        }
        .background(Color.cartBackground.ignoresSafeArea())
    }
    
    private var sortButton: some View {
        Button {
            
        } label: {
            Image("sort")
                .resizable()
                .scaledToFit()
                .frame(width: 21, height: 13)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Сортировка NFT")
    }
}

#Preview("С товарами") {
    CartView(viewModel: CartViewModel.mock())
}

#Preview("Пустая") {
    CartView(viewModel: CartViewModel())
}
