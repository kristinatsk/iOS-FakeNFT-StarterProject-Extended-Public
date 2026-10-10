//
//  UserCollectionNFTCell.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Урсан on 06.10.2026.
//

import SwiftUI

struct UserCollectionNftCell: View {
    let item: UserCollectionItem
    
    @State private var isFavorite = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topTrailing) {
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
                
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isFavorite.toggle()
                    }
                } label: {
                    Image(
                        isFavorite ? "like_pressed" : "like_default"
                    )
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .frame(width: 40, height: 40)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .frame(width: 40, height: 40)
            }
            
            Text(item.name)
                .font(
                    .system(
                        size: 15,
                        weight: .semibold
                    )
                )
                .lineLimit(1)
            
            HStack(alignment: .center) {
                Text(item.priceText)
                    .font(
                        .system(
                            size: 14,
                            weight: .medium
                        )
                    )
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Spacer(minLength: 4)
                
                Button {
                    // Логика покупки пока не реализована.
                } label: {
                    Image("cart_add")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.plain)
                .frame(width: 40, height: 40)
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
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
    }
}
