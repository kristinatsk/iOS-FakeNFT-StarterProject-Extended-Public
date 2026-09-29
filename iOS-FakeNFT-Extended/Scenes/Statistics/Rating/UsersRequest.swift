//
//  UsersRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Урсан on 26.09.2026.
//

import Foundation

struct UsersRequest: NetworkRequest {

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users")
    }

    var httpMethod: HttpMethod {
        .get
    }

    var dto: Encodable? {
        nil
    }
}
