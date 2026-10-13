//
//  CartTotalViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов on 22.09.2026.
//

import Foundation

struct CartTotalViewModel {
    let count: Int
    let totalPrice: Double
    let onPay: () -> Void
}
