//
//  PaymentService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов на 07.10.2026.
//

import Foundation

protocol PaymentService: Sendable {
    func setCurrency(orderId: String, currencyId: String) async throws
    func checkout(orderId: String, nftIDs: [String]) async throws
}

actor PaymentServiceImpl: PaymentService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func setCurrency(orderId: String, currencyId: String) async throws {
        _ = try await networkClient.send(request: PaymentRequest(orderId: orderId, currencyId: currencyId))
    }

    func checkout(orderId: String, nftIDs: [String]) async throws {
        _ = try await networkClient.send(request: CheckoutRequest(orderId: orderId, nftIDs: nftIDs))
    }
}
