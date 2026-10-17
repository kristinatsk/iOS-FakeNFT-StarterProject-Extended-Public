//
//  UserServiceProtocol.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Урсан on 04.10.2026.
//

import Foundation

protocol UserServiceProtocol {
    func fetchUsers() async throws -> [StatisticsUserDTO]
    func fetchUser(id: String) async throws -> UserDetailDTO
}
