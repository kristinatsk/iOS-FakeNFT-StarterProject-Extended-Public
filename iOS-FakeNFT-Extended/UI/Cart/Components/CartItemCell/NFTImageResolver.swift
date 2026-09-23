//
//  NFTImageResolver.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов on 23.09.2026.
//

import Kingfisher
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

struct NetworkNFTImage: View {
    let url: URL?

    var body: some View {
        Group {
            if let url {
                KFImage(url)
                    .placeholder { placeholder }
                    .resizable()
                    .scaledToFill()
            } else {
                placeholder
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
    }

    private var placeholder: some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .foregroundStyle(Color.cartTextPrimary.opacity(0.3))
            .padding(28)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
