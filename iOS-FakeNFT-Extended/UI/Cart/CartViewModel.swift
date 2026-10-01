//
//  CartViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов on 22.09.2026.
//

import Foundation
import Observation
import SwiftUI

@Observable
@MainActor
final class CartViewModel {
    private(set) var items: [CartItemCellModel]
    private var hasLoadedCart: Bool
    private(set) var isLoading = false
    private(set) var isLoadingItems = false
    private(set) var loadingError: String?
    private(set) var hasLoadingFailures = false
    private(set) var deletionError: String?
    private(set) var isDeletingItem = false
    private(set) var deletionRequestID: String?
    
    private let cartID: String
    private let cartService: CartService
    private let nftService: NftService
    
    var isEmpty: Bool { items.isEmpty }
    var totalPrice: Double { items.map(\.price).reduce(0, +) }
    
    init(
        cartService: CartService,
        nftService: NftService,
        cartID: String = "1",
        items: [CartItemCellModel]? = nil
    ) {
        self.cartService = cartService
        self.nftService = nftService
        self.cartID = cartID
        self.items = items ?? []
        self.hasLoadedCart = items != nil
    }
    
    func loadCart() async { await loadCart(forceReload: false) }
    func reloadCart() async { await loadCart(forceReload: true) }
    
    private var savedSortOption: CartSortOption {
        let rawValue = UserDefaults.standard.string(forKey: CartSortOption.userDefaultsKey)
        return rawValue.flatMap(CartSortOption.init(rawValue:)) ?? .defaultOption
    }

    private func loadCart(forceReload: Bool) async {
        guard !isLoading else { return }
        if hasLoadedCart && !forceReload { return }
        isLoading = true
        isLoadingItems = false
        loadingError = nil
        hasLoadingFailures = false
        defer {
            hasLoadedCart = loadingError == nil
            isLoadingItems = false
            isLoading = false
        }
        
        do {
            let cart = try await cartService.loadCart(id: cartID)
            items = cart.nfts.map { id in
                CartItemCellModel(
                    id: id,
                    name: "",
                    imageURL: nil,
                    rating: 0,
                    price: 0,
                    isLoading: true
                )
            }
            isLoading = false
            isLoadingItems = !cart.nfts.isEmpty
            
            let nftService = self.nftService
            await withTaskGroup(of: Result<Nft, Error>.self) { group in
                for id in cart.nfts {
                    group.addTask {
                        do { return .success(try await nftService.loadNft(id: id)) }
                        catch { return .failure(error) }
                    }
                }
                
                for await result in group {
                    switch result {
                    case .success(let nft):
                        guard let index = items.firstIndex(where: { $0.id == nft.id }) else { continue }
                        items[index] = makeCellModel(from: nft)
                    case .failure:
                        hasLoadedCart = false
                        hasLoadingFailures = true
                        loadingError = String(localized: "Error.network")
                    }
                }
            }
            isLoadingItems = false
            sortItems(by: savedSortOption)
            
        } catch {
            hasLoadingFailures = true
            loadingError = String(localized: "Error.network")
        }
    }
    
    func removeItem(id: String) async -> Bool {
        guard let itemIndex = items.firstIndex(where: { $0.id == id }),
              !isDeletingItem else { return false }
        
        let removedItem = items.remove(at: itemIndex)
        let remainingIDs = items.map(\.id)
        isDeletingItem = true
        deletionError = nil
        deletionRequestID = id
        defer {
            isDeletingItem = false
            deletionRequestID = nil
        }
        
        do {
            try await cartService.updateCart(id: cartID, nftIDs: remainingIDs)
            hasLoadedCart = true
            return true
        } catch {
            items.insert(removedItem, at: min(itemIndex, items.count))
            deletionError = String(localized: "Error.network")
            return false
        }
    }
    
    func sortItems(by option: CartSortOption) {
        switch option {
        case .price:
            items.sort { $0.price < $1.price }
        case .rating:
            items.sort { $0.rating > $1.rating }
        case .name:
            items.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }
    }
    
    func clearDeletionError() {
        deletionError = nil
    }
    
    private func makeCellModel(from nft: Nft) -> CartItemCellModel {
        CartItemCellModel(
            id: nft.id,
            name: nft.name ?? "NFT #\(nft.id)",
            imageURL: nft.images.first,
            rating: nft.rating ?? 0,
            price: nft.price ?? 0
        )
    }
}

// MARK: - Mocks

extension CartViewModel {
    static func mock(items: [CartItemCellModel] = CartItemCellModel.mocks) -> CartViewModel {
        CartViewModel(
            cartService: MockCartService(),
            nftService: MockNftService(),
            items: items
        )
    }
}
