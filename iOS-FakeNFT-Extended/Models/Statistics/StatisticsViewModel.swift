//
//  StatisticsViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Урсан on 26.09.2026.
//

import Foundation
import Combine

@MainActor
final class StatisticsViewModel: ObservableObject {

    @Published private(set) var users: [StatisticsUserDomain] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    @Published private(set) var sortOption: StatisticsSortOption

    private let service: StatisticsServiceProtocol
    private let mapper: StatisticsUsersMapperProtocol
    private let sorter: StatisticsUsersSorterProtocol
    private let sortStorage: StatisticsSortOptionStorageProtocol

    init(
        service: StatisticsServiceProtocol = StatisticsService(),
        mapper: StatisticsUsersMapperProtocol = StatisticsUsersMapper(),
        sorter: StatisticsUsersSorterProtocol = StatisticsUsersSorter(),
        sortStorage: StatisticsSortOptionStorageProtocol = StatisticsSortOptionStorage()
    ) {
        self.service = service
        self.mapper = mapper
        self.sorter = sorter
        self.sortStorage = sortStorage
        self.sortOption = sortStorage.load()
    }

    func viewDidLoad() {
        isLoading = true

        service.fetchUsers { [weak self] result in
            guard let self else { return }

            Task { @MainActor in
                self.isLoading = false

                switch result {
                case .success(let dto):
                    let mappedUsers = self.mapper.map(dto)

                    self.users = self.sorter.sort(
                        mappedUsers,
                        by: self.sortOption
                    )

                case .failure(let error):
                    print("Statistics error:", error)
                    self.errorMessage = "Не удалось загрузить статистику"
                }
            }
        }
    }

    func sort(by option: StatisticsSortOption) {
        sortOption = option
        sortStorage.save(option)

        users = sorter.sort(users, by: option)
    }
}
