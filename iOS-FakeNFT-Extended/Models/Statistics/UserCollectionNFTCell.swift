//
//  UserCollectionNFTCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Урсан on 06.10.2026.
//

import SwiftUI

struct UserCollectionNftCell: View {
    let item: UserCollectionItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: item.imageURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()

                case .failure:
                    placeholder

                case .empty:
                    ProgressView()

                @unknown default:
                    placeholder
                }
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .clipShape(
                RoundedRectangle(cornerRadius: 12)
            )

            Text(item.name)
                .font(
                    .system(
                        size: 15,
                        weight: .semibold
                    )
                )
                .lineLimit(1)

            HStack {
                Text(item.priceText)
                    .font(
                        .system(
                            size: 14,
                            weight: .medium
                        )
                    )

                Spacer()

                Button("Купить") {
                    // Логика покупки не входит в Module 3.
                }
                .font(
                    .system(
                        size: 14,
                        weight: .semibold
                    )
                )
            }
        }
    }

    private var placeholder: some View {
        ZStack {
            Color.gray.opacity(0.15)

            Image(systemName: "photo")
                .font(.system(size: 28))
                .foregroundStyle(.secondary)
        }
    }
}
