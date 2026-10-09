//
//  CurrenciesService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов on 06.10.2026.
//


import Foundation

protocol CurrenciesService: Sendable {
    func loadCurrencies() async throws -> [Currency]
}

actor CurrenciesServiceImpl: CurrenciesService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadCurrencies() async throws -> [Currency] {
        try await networkClient.send(request: CurrenciesRequest())
    }
}
