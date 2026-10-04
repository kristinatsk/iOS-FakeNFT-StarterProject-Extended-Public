//
//  StatisticsSortOption.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Урсан on 26.09.2026.
//

enum StatisticsSortOption: String, CaseIterable {
    case rating
    case name
    
    var title: String {
        switch self {
        case .rating:
            return "По рейтингу"
        case .name:
            return "По имени"
        }
    }
}
    