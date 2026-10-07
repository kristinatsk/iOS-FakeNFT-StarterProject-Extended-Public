//
//  CartService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов on 23.09.2026.
//

import Foundation

protocol CartService: Sendable {
    func loadCart(id: String) async throws -> CartItem
    func updateCart(id: String, nftIDs: [String]) async throws
    func clearCart(id: String) async throws
}

actor CartServiceImpl: CartService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadCart(id: String) async throws -> CartItem {
        try await networkClient.send(request: CartRequest(orderId: id))
    }
    
    func updateCart(id: String, nftIDs: [String]) async throws {
        _ = try await networkClient.send(request: CartRequest(orderId: id, action: .update(nfts: nftIDs)))
    }

    func clearCart(id: String) async throws {
        _ = try await networkClient.send(request: CartRequest(orderId: id, action: .clear))
    }
}
