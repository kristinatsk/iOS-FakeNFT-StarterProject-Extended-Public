//
//  StatisticsUsersSorter.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Урсан on 26.09.2026.
//

protocol StatisticsUsersSorterProtocol {
    func sort(
        _ users: [StatisticsUserDomain],
        by option: StatisticsSortOption
    ) -> [StatisticsUserDomain]
}

struct StatisticsUsersSorter: StatisticsUsersSorterProtocol {
    
    func sort(
        _ users: [StatisticsUserDomain],
        by option: StatisticsSortOption
    ) -> [StatisticsUserDomain] {
        
        switch option {
        case .name:
            return users.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
            
        case .rating:
            return users.sorted {
                $0.nftCount > $1.nftCount
            }
        }
    }
}
