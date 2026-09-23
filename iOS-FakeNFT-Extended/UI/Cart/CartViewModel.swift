//
//  CartViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов on 22.09.2026.
//

import Foundation
import SwiftUI

@MainActor
final class CartViewModel: ObservableObject {
    @Published private(set) var items: [CartItemCellModel] = []
    private var hasLoadedCart = false
    @Published private(set) var isLoading = false
    var hasLoadedCartData: Bool { hasLoadedCart }
    @Published private(set) var loadingError: String?

    private let cartService: CartService?
    private let nftService: NftService?

    var isEmpty: Bool { items.isEmpty }
    var totalPrice: Double { items.map(\.price).reduce(0, +) }

    init(items: [CartItemCellModel] = []) {
        self.items = items
        self.cartService = nil
        self.nftService = nil
    }

    init(cartService: CartService, nftService: NftService) {
        self.items = []
        self.cartService = cartService
        self.nftService = nftService
    }

    func loadCart(id: String = "1") async {
        guard let cartService, let nftService else { return }
        await loadCart(id: id, cartService: cartService, nftService: nftService)
    }

    func loadCart(
        id: String = "1",
        cartService: CartService,
        nftService: NftService
    ) async {
        await loadCart(id: id, cartService: cartService, nftService: nftService, forceReload: false)
    }

    func reloadCart(
        id: String = "1",
        cartService: CartService,
        nftService: NftService
    ) async {
        await loadCart(id: id, cartService: cartService, nftService: nftService, forceReload: true)
    }

    private func loadCart(
        id: String,
        cartService: CartService,
        nftService: NftService,
        forceReload: Bool
    ) async {
        guard !isLoading else { return }
        if hasLoadedCart && !forceReload { return }
        isLoading = true
        loadingError = nil
        defer {
            hasLoadedCart = loadingError == nil
            isLoading = false
        }

        do {
            let cart = try await cartService.loadCart(id: id)
            let nfts = try await withThrowingTaskGroup(of: Nft.self) { group in
                for id in cart.nfts {
                    group.addTask {
                        try await nftService.loadNft(id: id)
                    }
                }

                var loadedNfts: [Nft] = []
                for try await nft in group {
                    loadedNfts.append(nft)
                }
                return loadedNfts
            }

            let nftsByID = Dictionary(uniqueKeysWithValues: nfts.map { ($0.id, $0) })
            items = cart.nfts.compactMap { id in
                guard let nft = nftsByID[id] else { return nil }
                return makeCellModel(from: nft)
            }
        } catch {
            loadingError = NSLocalizedString("Error.network", comment: "")
        }
    }

    // TODO: Add NFT removal from the cart through the order API.

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
    static func mock() -> CartViewModel {
        CartViewModel(items: CartItemCellModel.mocks)
    }
}
