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

    @Environment(ServicesAssembly.self) private var servicesAssembly
    private let loadsRemoteCart: Bool
    
    init(viewModel: CartViewModel? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel ?? CartViewModel())
        loadsRemoteCart = viewModel == nil
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.loadingError {
                VStack(spacing: 12) {
                    Text(errorMessage)
                        .font(.caption1)
                        .foregroundStyle(Color.cartTextPrimary)
                        .multilineTextAlignment(.center)
                    Button(NSLocalizedString("Error.repeat", comment: "")) {
                        Task {
                            await viewModel.reloadCart(
                                id: "1",
                                cartService: servicesAssembly.cartService,
                                nftService: servicesAssembly.nftService
                            )
                        }
                    }
                    .font(.bodyBold)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.isEmpty {
                CartEmptyView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        .task {
            guard loadsRemoteCart else { return }
            await viewModel.loadCart(
                id: "1",
                cartService: servicesAssembly.cartService,
                nftService: servicesAssembly.nftService
            )
        }
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
        .environment(\.nftImageResolver) { AnyView(MockNFTImage(url: $0)) }
        .environment(ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl()))
}

#Preview("Пустая") {
    CartView(viewModel: CartViewModel())
        .environment(ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl()))
}
