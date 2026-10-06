//
//  UserCollectionViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Урсан on 06.10.2026.
//

import Foundation

@MainActor
final class UserCollectionViewModel: ObservableObject {
    @Published private(set) var items: [UserCollectionItem] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let userId: String
    private let userService: UserServiceProtocol
    private let nftService: NftService

    init(
        userId: String,
        userService: UserServiceProtocol,
        nftService: NftService
    ) {
        self.userId = userId
        self.userService = userService
        self.nftService = nftService
    }

    func load() {
        guard !isLoading else {
            return
        }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let user = try await userService.fetchUser(
                    id: userId
                )

                var loadedItems: [UserCollectionItem] = []

                for nftId in user.nfts {
                    let nft = try await nftService.loadNft(
                        id: nftId
                    )

                    let item = UserCollectionItem(
                        id: nft.id,
                        imageURL: nft.images.first.flatMap(URL.init),
                        name: nft.name,
                        priceText: String(
                            format: "%.2f ETH",
                            nft.price
                        )
                    )

                    loadedItems.append(item)
                }

                items = loadedItems
                isLoading = false
            } catch {
                isLoading = false
                errorMessage = "Не удалось загрузить коллекцию NFT"
            }
        }
    }
}
