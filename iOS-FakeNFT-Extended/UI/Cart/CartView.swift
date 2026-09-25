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
    @State private var showSortDialog = false
    
    @AppStorage(CartSortOption.userDefaultsKey)
    private var selectedSortOption = CartSortOption.defaultOption.rawValue

    private var selectedSortOptionValue: CartSortOption {
        CartSortOption(rawValue: selectedSortOption) ?? .defaultOption
    }

    init(viewModel: CartViewModel) {
        _viewModel = State(initialValue: viewModel)
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
                    Button("Error.repeat") {
                        Task {
                            await viewModel.reloadCart()
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
        .animation(.none, value: viewModel.items.map(\.id))
        .onChange(of: viewModel.isLoadingItems) { _, isLoadingItems in
            if isLoadingItems {
                ProgressHUD.animate(nil, interaction: false)
            } else if viewModel.hasLoadingFailures {
                ProgressHUD.failed(String(localized: "Error.network"), interaction: false, delay: 2)
            } else {
                ProgressHUD.dismiss()
            }
        }
        .onChange(of: viewModel.hasLoadingFailures) { _, hasFailures in
            guard hasFailures, !viewModel.isLoadingItems else { return }
            ProgressHUD.failed(String(localized: "Error.network"), interaction: false, delay: 2)
        }
        .task {
            await viewModel.loadCart()
            viewModel.sortItems(by: selectedSortOptionValue)
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
                        Task {
                            let deleted = await viewModel.removeItem(id: item.id)
                            if deleted {
                                itemPendingDeletion = nil
                            } else if let message = viewModel.deletionError {
                                ProgressHUD.failed(message, interaction: false, delay: 2)
                                viewModel.clearDeletionError()
                            }
                        }
                    },
                    onCancel: {
                        itemPendingDeletion = nil
                    },
                    isDeleting: viewModel.deletionRequestID == item.id
                )
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea()
    }

    private var sortButton: some View {
        Button {
            showSortDialog = true
        } label: {
            Image(.sort)
                .resizable()
                .scaledToFit()
                .frame(width: 21, height: 13)
        }
        .confirmationDialog(
            "Cart.sort",
            isPresented: $showSortDialog,
            titleVisibility: .visible
        ) {
            sortDialog
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Accessibility.cart.sort")
    }
    
    @ViewBuilder
    private var sortDialog: some View {
        Button("Cart.sort.price") {
            selectedSortOption = CartSortOption.price.rawValue
            viewModel.sortItems(by: selectedSortOptionValue)
        }
        
        Button("Cart.sort.rating") {
            selectedSortOption = CartSortOption.rating.rawValue
            viewModel.sortItems(by: selectedSortOptionValue)
        }
        
        Button("Cart.sort.name") {
            selectedSortOption = CartSortOption.name.rawValue
            viewModel.sortItems(by: selectedSortOptionValue)
        }
        
        Button("Common.cancel", role: .cancel) { }
    }
}

#Preview("С товарами") {
    CartView(viewModel: .mock())
        .environment(\.nftImageResolver) { AnyView(MockNFTImage(url: $0)) }
}

#Preview("Пустая") {
    CartView(viewModel: .mock(items: []))
}
