//
//  UserCollectionModule.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Урсан on 06.10.2026.
//

import SwiftUI

enum UserCollectionModule {
    @MainActor
    static func make(
        userId: String
    ) -> some View {
        let nftStorage = NftStorageImpl()

        let nftService = NftServiceImpl(
            networkClient: DefaultNetworkClient(),
            storage: nftStorage
        )

        let viewModel = UserCollectionViewModel(
            userId: userId,
            userService: UserService(),
            nftService: nftService
        )

        return UserCollectionView(
            viewModel: viewModel
        )
    }
}

