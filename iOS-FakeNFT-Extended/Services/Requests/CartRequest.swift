//
//  CartRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов on 23.09.2026.
//

import Foundation

struct CartRequest: NetworkRequest {
    enum Action {
        case fetch
        case update(nfts: [String])
        case clear
    }

    private enum Field {
        static let nfts = "nfts"
    }

    let orderId: String
    let action: Action

    init(orderId: String, action: Action = .fetch) {
        self.orderId = orderId
        self.action = action
    }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(orderId)")
    }

    var httpMethod: HttpMethod {
        switch action {
        case .fetch: .get
        case .update, .clear: .put
        }
    }

    var contentType: String? {
        switch action {
        case .fetch: nil
        case .update, .clear: "application/x-www-form-urlencoded"
        }
    }

    var formURLEncodedBody: Data? {
        switch action {
        case .fetch:
            nil
        case .update(let nfts):
            FormURLEncoder.encode([Field.nfts: nfts.joined(separator: ",")])
        case .clear:
            FormURLEncoder.encodeEmptyArray(key: Field.nfts)
        }
    }
}
