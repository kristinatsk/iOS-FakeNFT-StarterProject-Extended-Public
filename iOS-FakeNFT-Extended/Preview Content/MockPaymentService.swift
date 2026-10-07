//
//  MockPaymentService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов на 07.10.2026.
//

import Foundation

struct MockPaymentService: PaymentService {
    var shouldFailCheckout = false
    var shouldFailCurrency = false

    func setCurrency(orderId: String, currencyId: String) async throws {
        if shouldFailCurrency { throw URLError(.notConnectedToInternet) }
    }

    func checkout(orderId: String, nftIDs: [String]) async throws {
        if shouldFailCheckout { throw URLError(.badServerResponse) }
    }
}