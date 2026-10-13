//
//  CurrenciesRequest.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов on 06.10.2026.
//

import Foundation

struct CurrenciesRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }
}
