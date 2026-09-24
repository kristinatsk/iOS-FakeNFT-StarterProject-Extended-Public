//
//  CartService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов on 23.09.2026.
//

import Foundation

protocol CartService {
    func loadCart(id: String) async throws -> CartItem
}

@MainActor
final class CartServiceImpl: CartService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadCart(id: String) async throws -> CartItem {
        try await networkClient.send(request: CartRequest(id: id))
    }
}
