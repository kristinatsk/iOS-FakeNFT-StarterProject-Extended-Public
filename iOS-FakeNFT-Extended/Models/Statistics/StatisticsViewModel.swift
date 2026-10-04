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

            Task {
                do {
                    let dto = try await service.fetchUsers()

                    let mappedUsers = mapper.map(dto)

                    users = sorter.sort(
                        mappedUsers,
                        by: sortOption
                    )

                    isLoading = false

                } catch {
                    print("Statistics error:", error)
                    isLoading = false
                    errorMessage = "Не удалось загрузить статистику"
                }
            }
        }

        func sort(by option: StatisticsSortOption) {
            sortOption = option
            sortStorage.save(option)

            users = sorter.sort(
                users,
                by: option
            )
        }
    }
