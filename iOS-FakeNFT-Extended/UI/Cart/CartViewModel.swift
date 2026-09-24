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
    private(set) var items: [CartItemCellModel] = []
    private var hasLoadedCart = false
    private(set) var isLoading = false
    private(set) var isLoadingItems = false
    private(set) var loadingError: String?
    private(set) var hasLoadingFailures = false

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
        isLoadingItems = false
        loadingError = nil
        hasLoadingFailures = false
        defer {
            hasLoadedCart = loadingError == nil
            isLoadingItems = false
            isLoading = false
        }

        do {
            let cart = try await cartService.loadCart(id: id)
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

            await withTaskGroup(of: Result<Nft, Error>.self) { group in
                for id in cart.nfts {
                    group.addTask {
                        do {
                            return .success(try await nftService.loadNft(id: id))
                        } catch {
                            return .failure(error)
                        }
                    }
                }

                for await result in group {
                    switch result {
                    case .success(let nft):
                        guard let index = items.firstIndex(where: { $0.id == nft.id }) else { continue }
                        items[index] = makeCellModel(from: nft)
                    case .failure:
                        hasLoadingFailures = true
                        loadingError = NSLocalizedString("Error.network", comment: "")
                    }
                }
            }
            isLoadingItems = false

        } catch {
            hasLoadingFailures = true
            loadingError = NSLocalizedString("Error.network", comment: "")
            isLoadingItems = false
            isLoading = false
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
