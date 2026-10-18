//
//  UserCollectionBridgeView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Урсан on 04.10.2026.
//

import SwiftUI

struct UserCollectionBridgeView: UIViewControllerRepresentable {
    let userId: String
    let servicesAssembly: ServicesAssembly

    func makeUIViewController(context: Context) -> UIViewController {
        UserCollectionModule.make(
            userId: userId,
            servicesAssembly: servicesAssembly
        )
    }

    func updateUIViewController(
        _ uiViewController: UIViewController,
        context: Context
    ) {
    }
}
