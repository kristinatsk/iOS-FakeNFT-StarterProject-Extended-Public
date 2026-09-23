//
//  CartItemCellModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов on 22.09.2026.
//

import Foundation

struct CartItemCellModel: Identifiable {
    let id: String
    let name: String
    let imageURL: URL?
    let rating: Int
    let price: Double
    var isLoading: Bool = false
}

// MARK: - Mocks

extension CartItemCellModel {
    static let mocks: [CartItemCellModel] = [
        CartItemCellModel(
            id: "1",
            name: "Spring",
            imageURL: URL(string: "https://example.com/spring.png"),
            rating: 5,
            price: 1.78
        ),
        CartItemCellModel(
            id: "2",
            name: "April",
            imageURL: URL(string: "https://example.com/april.png"),
            rating: 3,
            price: 1.78
        ),
        CartItemCellModel(
            id: "3",
            name: "Greena",
            imageURL: URL(string: "https://example.com/greena.png"),
            rating: 1,
            price: 1.78
        )
    ]
}
