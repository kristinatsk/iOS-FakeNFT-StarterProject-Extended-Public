//
//  MockCurrenciesService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов на 06.10.2026.
//


import Foundation

struct MockCurrenciesService: CurrenciesService {
    func loadCurrencies() async throws -> [Currency] {
        [
            Currency(
                id: "1",
                title: "Bitcoin",
                name: "BTC",
                image: URL(string: "https://example.com/bitcoin.png")!
            ),
            Currency(
                id: "2",
                title: "Ethereum",
                name: "ETH",
                image: URL(string: "https://example.com/ethereum.png")!
            ),
            Currency(
                id: "3",
                title: "Tether",
                name: "USDT",
                image: URL(string: "https://example.com/tether.png")!
            )
        ]
    }
}
