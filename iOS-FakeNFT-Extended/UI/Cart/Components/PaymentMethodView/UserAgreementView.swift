//
//  UserAgreementView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов on 06.10.2026.
//

import SwiftUI
import WebKit

struct UserAgreementView: View {
    @Environment(\.colorScheme) private var colorScheme

    private let url = AppURL.userAgreement

    var body: some View {
        NavigationStack {
            AgreementWebView(
                url: url,
                colorScheme: colorScheme
            )
            .ignoresSafeArea(edges: .bottom)
            .navigationTitle("Payment.agreement.title")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct AgreementWebView: UIViewRepresentable {
    let url: URL
    let colorScheme: ColorScheme

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator

        webView.load(URLRequest(url: url))

        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        context.coordinator.colorScheme = colorScheme
        applyTheme(to: webView)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(colorScheme: colorScheme)
    }

    private func applyTheme(to webView: WKWebView) {
        webView.overrideUserInterfaceStyle =
            colorScheme == .dark ? .dark : .light

        guard !webView.isLoading else { return }

        webView.evaluateJavaScript(Self.themeScript(for: colorScheme))
    }

    private static func themeScript(for colorScheme: ColorScheme) -> String {
        if colorScheme == .dark {
            return """
            (() => {
                let style = document.getElementById('dark-mode-style');

                if (!style) {
                    style = document.createElement('style');
                    style.id = 'dark-mode-style';
                    document.head.appendChild(style);
                }

                style.textContent = `
                    html {
                        filter: invert(1) hue-rotate(180deg) !important;
                        background-color: #fff !important;
                    }

                    img,
                    video,
                    canvas,
                    iframe,
                    svg,
                    picture {
                        filter: invert(1) hue-rotate(180deg) !important;
                    }
                `;
            })();
            """
        } else {
            return """
            document.getElementById('dark-mode-style')?.remove();
            """
        }
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        var colorScheme: ColorScheme

        init(colorScheme: ColorScheme) {
            self.colorScheme = colorScheme
        }

        func webView(
            _ webView: WKWebView,
            didFinish navigation: WKNavigation!
        ) {
            webView.evaluateJavaScript(
                AgreementWebView.themeScript(for: colorScheme)
            )
        }
    }
}

#Preview {
    UserAgreementView()
}
