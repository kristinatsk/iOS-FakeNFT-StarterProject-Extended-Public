//
//  UserCardModule.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Урсан on 04.10.2026.
//

import SwiftUI

enum UserCardModule {
    @MainActor
    static func make(
        userId: String
    ) -> some View {
        UserCardView(
            userId: userId,
            viewModel: UserCardViewModel()
        )
    }
}
