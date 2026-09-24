//
//  CartView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов на 22.09.2026.
//

import ProgressHUD
import SwiftUI

struct CartView: View {
    @State private var viewModel: CartViewModel
    @State private var itemPendingDeletion: CartItemCellModel?

    @Environment(ServicesAssembly.self) private var servicesAssembly
    private let loadsRemoteCart: Bool
    
    init(viewModel: CartViewModel? = nil) {
        _viewModel = State(initialValue: viewModel ?? CartViewModel())
        loadsRemoteCart = viewModel == nil
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading && viewModel.items.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.loadingError, viewModel.items.isEmpty {
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
            } else if viewModel.isEmpty && viewModel.loadingError == nil {
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
                                    CartItemCellView(model: item) { item in
                                        itemPendingDeletion = item
                                    }
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
        .toolbar(itemPendingDeletion == nil ? .visible : .hidden, for: .tabBar)
        .background(Color.cartBackground.ignoresSafeArea())
        .overlay {
            if let itemPendingDeletion {
                deleteConfirmationOverlay(for: itemPendingDeletion)
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: itemPendingDeletion?.id)
        .onChange(of: viewModel.isLoadingItems) { _, isLoadingItems in
            if isLoadingItems {
                ProgressHUD.animate(nil, interaction: false)
            } else if !viewModel.hasLoadingFailures {
                ProgressHUD.dismiss()
            } else {
                ProgressHUD.failed(NSLocalizedString("Error.network", comment: ""), interaction: false, delay: 2)
            }
        }
        .onChange(of: viewModel.hasLoadingFailures) { _, hasFailures in
            guard hasFailures, !viewModel.isLoadingItems else { return }
            ProgressHUD.failed(NSLocalizedString("Error.network", comment: ""), interaction: false, delay: 2)
        }
        .task {
            guard loadsRemoteCart else { return }
            await viewModel.loadCart(
                id: "1",
                cartService: servicesAssembly.cartService,
                nftService: servicesAssembly.nftService
            )
        }
    }
    
    private func deleteConfirmationOverlay(for item: CartItemCellModel) -> some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .fill(Color.white.opacity(13.0 / 255.0))
                    .background(.ultraThinMaterial)
                    .ignoresSafeArea()
                    .onTapGesture {
                        itemPendingDeletion = nil
                    }
                    .accessibilityHidden(true)

                CartDeleteConfirmationView(
                    item: item,
                    onDelete: {
                        // Deletion is intentionally not connected yet.
                    },
                    onCancel: {
                        itemPendingDeletion = nil
                    }
                )
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea()
    }

    private var sortButton: some View {
        Button {
            
        } label: {
            Image(.sort)
                .resizable()
                .scaledToFit()
                .frame(width: 21, height: 13)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(NSLocalizedString("Accessibility.cart.sort", comment: ""))
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
