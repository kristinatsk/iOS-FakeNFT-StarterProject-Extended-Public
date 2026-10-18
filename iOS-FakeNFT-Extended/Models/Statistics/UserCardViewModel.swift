//
//  UserCardViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Урсан on 04.10.2026.
//

import Foundation

@MainActor
final class UserCardViewModel: ObservableObject {
    @Published private(set) var model: UserCardModel?
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let service: UserServiceProtocol

    private var userId: String?
    private var websiteURL: URL?

    init(service: UserServiceProtocol = UserService()) {
        self.service = service
    }

    func load(userId: String) {
        self.userId = userId
        isLoading = true

        Task {
            do {
                let dto = try await service.fetchUser(id: userId)

                let description: String

                if let dtoDescription = dto.description,
                   !dtoDescription.isEmpty {
                    description = dtoDescription
                } else {
                    description = "Нет описания"
                }

                model = UserCardModel(
                    avatarURLString: dto.avatar,
                    name: dto.name,
                    description: description,
                    website: dto.website,
                    nftCount: dto.nfts.count
                )

                websiteURL = URL(string: dto.website)
                isLoading = false
            } catch {
                isLoading = false
                errorMessage = "Не удалось загрузить пользователя"
            }
        }
    }

    func websiteTapped() -> URL? {
        guard let websiteURL else {
            errorMessage = "Некорректная ссылка"
            return nil
        }

        return websiteURL
    }
}
