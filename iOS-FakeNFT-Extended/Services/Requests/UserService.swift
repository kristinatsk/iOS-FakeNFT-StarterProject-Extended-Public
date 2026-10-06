//
//  UserService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Урсан on 04.10.2026.
//

import Foundation

actor UserService: UserServiceProtocol {
    private let client: NetworkClient

    init(client: NetworkClient = DefaultNetworkClient()) {
        self.client = client
    }

    func fetchUsers() async throws -> [StatisticsUserDTO] {
        let request = UsersRequest()
        return try await client.send(request: request)
    }

    func fetchUser(id: String) async throws -> UserDetailDTO {
        let request = UserByIdRequest(id: id)
        return try await client.send(request: request)
    }
}
