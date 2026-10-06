//
//  UserAgreementView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов on 06.10.2026.
//

import SwiftUI
import WebKit

struct UserAgreementView: View {
    private let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse")!

    var body: some View {
        NavigationStack {
            AgreementWebView(url: url)
                .ignoresSafeArea(edges: .bottom)
                .navigationTitle("Payment.agreement.title")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct AgreementWebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        guard webView.url != url else { return }
        webView.load(URLRequest(url: url))
    }
}

#Preview {
    UserAgreementView()
}
