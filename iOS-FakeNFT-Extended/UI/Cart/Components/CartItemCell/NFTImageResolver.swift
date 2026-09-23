//
//  NFTImageResolver.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов on 23.09.2026.
//

import SwiftUI

// MARK: - Environment key

private struct NFTImageResolverKey: EnvironmentKey {
    static let defaultValue: (URL?) -> AnyView = { url in
        AnyView(NetworkNFTImage(url: url))
    }
}

extension EnvironmentValues {
    var nftImageResolver: (URL?) -> AnyView {
        get { self[NFTImageResolverKey.self] }
        set { self[NFTImageResolverKey.self] = newValue }
    }
}

// MARK: - Реальная реализация (сегодня AsyncImage)

/// TODO(1.2): заменить тело на KFImage(url).resizable()
struct NetworkNFTImage: View {
    let url: URL?
    
    var body: some View {
        AsyncImage(url: url) { phase in
            if case .success(let image) = phase {
                image.resizable()
            } else {
                placeholder
            }
        }
    }
    
    private var placeholder: some View {
        Image(systemName: "photo")
            .resizable()
            .foregroundStyle(Color.cartTextPrimary.opacity(0.3))
    }
}

// MARK: - Мок для превью

struct MockNFTImage: View {
    let url: URL?
    
    var body: some View {
        if let url, let name = mockImageName(from: url) {
            Image(name).resizable()
        } else {
            Image(systemName: "photo")
                .resizable()
                .foregroundStyle(Color.cartTextPrimary.opacity(0.3))
        }
    }
    
    private func mockImageName(from url: URL) -> String? {
        let path = url.lastPathComponent.lowercased()
        if path.contains("spring") { return "spring" }
        if path.contains("april") { return "april" }
        if path.contains("greena") { return "greena" }
        return nil
    }
}
