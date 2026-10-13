//
//  StatisticsService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Урсан on 26.09.2026.
//

import Foundation

protocol StatisticsServiceProtocol: Sendable {
    func fetchUsers() async throws -> [StatisticsUserDTO]
}

actor StatisticsService: StatisticsServiceProtocol {
    private let client: NetworkClient

    init(client: NetworkClient = DefaultNetworkClient()) {
        self.client = client
    }

    func fetchUsers() async throws -> [StatisticsUserDTO] {
        let request = UsersRequest()
        return try await client.send(request: request)
    }
}
