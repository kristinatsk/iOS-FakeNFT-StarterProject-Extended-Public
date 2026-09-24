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
        case .update: .put
        }
    }

    var contentType: String? {
        switch action {
        case .fetch: nil
        case .update: "application/x-www-form-urlencoded"
        }
    }

    var formURLEncodedBody: Data? {
        guard case .update(let nfts) = action else { return nil }
        return FormURLEncoder.encode(["nfts": nfts.joined(separator: ",")])
    }
}

private enum FormURLEncoder {
    private static let allowed = CharacterSet(
        charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"
    )

    static func encode(_ fields: [String: String]) -> Data {
        let body = fields
            .map { key, value in
                let k = key.addingPercentEncoding(withAllowedCharacters: allowed) ?? key
                let v = value.addingPercentEncoding(withAllowedCharacters: allowed) ?? value
                return "\(k)=\(v)"
            }
            .joined(separator: "&")
        return Data(body.utf8)
    }
}
