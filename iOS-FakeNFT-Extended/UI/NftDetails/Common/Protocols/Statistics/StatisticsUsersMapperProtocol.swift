//
//  StatisticsUsersMapperProtocol.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Урсан on 26.09.2026.
//

protocol StatisticsUsersMapperProtocol {
    func map(_ dto: [StatisticsUserDTO]) -> [StatisticsUserDomain]
}
