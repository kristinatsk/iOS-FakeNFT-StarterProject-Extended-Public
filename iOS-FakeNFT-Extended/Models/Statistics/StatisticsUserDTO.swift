//
//  StatisticsUserDTO.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Урсан on 26.09.2026.
//

import Foundation

struct StatisticsUserDTO: Decodable, Sendable {
    let id: String
    let name: String
    let avatar: String
    let description: String?
    let website: String
    let nfts: [String]
    let rating: String
}
