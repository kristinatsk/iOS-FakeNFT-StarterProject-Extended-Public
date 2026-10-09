//
//  Currency.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов on 06.10.2026.
//

import Foundation

struct Currency: Decodable, Identifiable, Hashable {
    let id: String
    let title: String
    let name: String
    let imageURL: URL

    private enum CodingKeys: String, CodingKey {
        case id, title, name
        case imageURL = "image"
    }
}
