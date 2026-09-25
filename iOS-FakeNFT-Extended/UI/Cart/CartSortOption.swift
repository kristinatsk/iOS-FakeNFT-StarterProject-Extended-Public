//
//  CartSortOption.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов на 25.09.2026.
//

import Foundation

enum CartSortOption: String, CaseIterable, Identifiable {
    case price
    case rating
    case name

    var id: String { rawValue }

    static let userDefaultsKey = "cart.sortOption"
    static let defaultOption = CartSortOption.price
}
