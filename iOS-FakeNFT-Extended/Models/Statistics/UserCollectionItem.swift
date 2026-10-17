//
//  UserCollectionItem.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Урсан on 06.10.2026.
//

import Foundation

struct UserCollectionItem: Identifiable {
    let id: String
    let imageURL: URL?
    let name: String
    let priceText: String
}
