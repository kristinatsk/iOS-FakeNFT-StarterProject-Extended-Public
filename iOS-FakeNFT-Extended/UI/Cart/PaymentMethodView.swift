//
//  PaymentMethodView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов на 06.10.2026.
//

import Foundation
import ProgressHUD
import SwiftUI

struct PaymentMethodView: View {
    private let currenciesService: CurrenciesService
    private let onPay: (Currency) -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var selectedCurrencyID: String?
    @State private var currencies: [Currency] = []
    @State private var isShowingAgreement = false
    @State private var loadingError: String?
    @State private var isLoading = false

    init(
        currenciesService: CurrenciesService,
        onPay: @escaping (Currency) -> Void = { _ in }
    ) {
        self.currenciesService = currenciesService
        self.onPay = onPay
    }

    private var selectedCurrency: Currency? {
        currencies.first { $0.id == selectedCurrencyID }
    }

    var body: some View {
        VStack(spacing: 0) {
            PaymentMethodHeaderView {
                dismiss()
            }

            Group {
                if isLoading && currencies.isEmpty {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let loadingError, currencies.isEmpty {
                    VStack(spacing: 12) {
                        Text(loadingError)
                            .font(.caption1)
                            .foregroundStyle(Color.cartTextPrimary)
                            .multilineTextAlignment(.center)

                        Button("Error.repeat") {
                            Task { await loadCurrencies() }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)],
                            spacing: 10
                        ) {
                            ForEach(currencies) { currency in
                                CryptoCurrencyCell(
                                    currency: currency,
                                    isSelected: selectedCurrencyID == currency.id
                                ) {
                                    selectedCurrencyID = currency.id
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 36)
                    }
                    // Повторная загрузка не должна подменять уже загруженный контент
                    .overlay {
                        if isLoading {
                            ProgressView()
                        }
                    }
                }
            }

            VStack(alignment: .leading, spacing: 28) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Payment.agreement.description")
                        .font(.caption2)
                        .foregroundStyle(Color.cartTextPrimary)

                    Button {
                        isShowingAgreement = true
                    } label: {
                        Text("Payment.agreement.link")
                            .font(.caption2)
                            .foregroundStyle(.blue)
                    }
                    .buttonStyle(.plain)
                }

                Button {
                    guard let selectedCurrency else { return }
                    onPay(selectedCurrency)
                } label: {
                    Text("Payment.pay")
                        .font(.bodyBold)
                        .foregroundStyle(Color.cartButtonText)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(selectedCurrency == nil ? Color.cartTextPrimary.opacity(0.25) : Color.cartButtonBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
                .disabled(selectedCurrency == nil)
            }
            .padding(.horizontal, 16)
            .padding(.top, 22)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.cartSeparator)
            .clipShape(.rect(topLeadingRadius: 12, topTrailingRadius: 12))
        }
        .background(Color.cartBackground.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingAgreement) {
            UserAgreementView()
        }
        .task {
            await loadCurrencies()
        }
    }

    private func loadCurrencies() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            currencies = try await currenciesService.loadCurrencies()
            loadingError = nil
            ProgressHUD.dismiss()
        } catch {
            let message = String(localized: "Error.network")
            if currencies.isEmpty {
                // Первый запуск: показываем экран ошибки с кнопкой повтора
                loadingError = message
            } else {
                // Данные уже на экране: не блокируем список, а сообщаем о проблеме
                loadingError = nil
                ProgressHUD.failed(message, interaction: false, delay: 2)
            }
        }
    }
}

#Preview {
    NavigationStack {
        PaymentMethodView(currenciesService: MockCurrenciesService())
            .environment(\.nftImageResolver) { AnyView(MockNFTImage(url: $0)) }
    }
}
