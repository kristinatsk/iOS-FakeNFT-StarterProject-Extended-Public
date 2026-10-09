//
//  PaymentRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов на 07.10.2026.
//

import Foundation

/// `GET /api/v1/orders/{orderId}/payment/{currencyId}` — выбор валюты для заказа.
struct PaymentRequest: NetworkRequest {
    let orderId: String
    let currencyId: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(orderId)/payment/\(currencyId)")
    }
}

/// `POST /api/v1/orders/{orderId}` — выполнение заказа.
struct CheckoutRequest: NetworkRequest {
    private enum Field {
        static let nfts = "nfts"
    }

    let orderId: String
    let nftIDs: [String]

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(orderId)")
    }

    var httpMethod: HttpMethod { .post }

    var contentType: String? { "application/x-www-form-urlencoded" }

    var formURLEncodedBody: Data? {
        FormURLEncoder.encode(key: Field.nfts, values: nftIDs)
    }
}
