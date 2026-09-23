//
//  CartItem.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов on 23.09.2026.
//

import Foundation

struct CartItem: Decodable {
    let id: String
    let nfts: [String]
}
