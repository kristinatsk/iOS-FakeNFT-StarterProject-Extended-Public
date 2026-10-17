//
//  MockServices.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов on 24.09.2026.
//

import Foundation

struct MockCartService: CartService {
    var nftIDs: [String] = []
    var shouldFailUpdate = false
    var shouldFailClear = false

    func loadCart(id: String) async throws -> CartItem {
        CartItem(id: id, nfts: nftIDs)
    }

    func updateCart(id: String, nftIDs: [String]) async throws {
        if shouldFailUpdate { throw URLError(.notConnectedToInternet) }
    }

    func clearCart(id: String) async throws {
        if shouldFailClear { throw URLError(.notConnectedToInternet) }
    }
}

struct MockNftService: NftService {
    func loadNft(id: String) async throws -> Nft {
        throw URLError(.badServerResponse)
    }
}
