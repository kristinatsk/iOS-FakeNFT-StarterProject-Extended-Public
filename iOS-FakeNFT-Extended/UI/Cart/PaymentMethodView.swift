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
    @State private var viewModel: PaymentViewModel

    private let onPaySuccess: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var isShowingAgreement = false

    init(
        viewModel: PaymentViewModel,
        onPaySuccess: @escaping () -> Void = { }
    ) {
        _viewModel = State(initialValue: viewModel)
        self.onPaySuccess = onPaySuccess
    }

    private var selectedCurrency: Currency? {
        viewModel.selectedCurrency
    }

    var body: some View {
        VStack(spacing: 0) {
            PaymentMethodHeaderView {
                dismiss()
            }

            Group {
                if viewModel.isInitialLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let currenciesError = viewModel.currenciesError, viewModel.currencies.isEmpty {
                    VStack(spacing: 12) {
                        Text(currenciesError)
                            .font(.caption1)
                            .foregroundStyle(Color.cartTextPrimary)
                            .multilineTextAlignment(.center)

                        Button("Error.repeat") {
                            Task { await viewModel.loadCurrencies() }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)],
                            spacing: 10
                        ) {
                            ForEach(viewModel.currencies) { currency in
                                CryptoCurrencyCell(
                                    currency: currency,
                                    isSelected: viewModel.selectedCurrencyID == currency.id
                                ) {
                                    viewModel.selectCurrency(id: currency.id)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 36)
                    }
                    .overlay {
                        if viewModel.isLoadingCurrencies {
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
                    Task { await pay(with: selectedCurrency) }
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
                .disabled(selectedCurrency == nil || viewModel.isLoading)
            }
            .padding(.horizontal, 16)
            .padding(.top, 22)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.cartSeparator)
            .clipShape(.rect(topLeadingRadius: 12, topTrailingRadius: 12))
            .background(Color.cartSeparator.ignoresSafeArea(edges: .bottom))
        }
        .background(Color.cartBackground.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingAgreement) {
            UserAgreementView()
        }
        .task {
            await viewModel.loadCurrencies()
        }
        .onChange(of: viewModel.currenciesError) { _, error in
            // Ошибка при непустом списке показывается только всплывающим HUD
            guard let error, !viewModel.currencies.isEmpty else { return }
            ProgressHUD.failed(error, interaction: false, delay: 2)
        }
        .onChange(of: viewModel.state) { _, newState in
            switch newState {
            case .success:
                ProgressHUD.dismiss()
                onPaySuccess()
            case .loading:
                ProgressHUD.animate(nil, interaction: false)
            case .idle, .error:
                ProgressHUD.dismiss()
            }
        }
        .alert("Payment.error.title", isPresented: errorAlertBinding) {
            Button("Error.repeat") {
                guard let selectedCurrency else { return }
                Task { await viewModel.retry(currencyId: selectedCurrency.id) }
            }
            Button("Common.cancel", role: .cancel) {
                viewModel.cancel()
                dismiss()
            }
        } message: {
            Text("Payment.error.message")
        }
    }

    private var errorAlertBinding: Binding<Bool> {
        Binding(
            get: { viewModel.state == .error },
            set: { isPresented in
                if !isPresented, viewModel.state == .error {
                    viewModel.cancel()
                }
            }
        )
    }

    private func pay(with currency: Currency) async {
        await viewModel.pay(currencyId: currency.id)
    }
}

#Preview {
    NavigationStack {
        PaymentMethodView(
            viewModel: PaymentViewModel.mock()
        )
        .environment(\.nftImageResolver) { AnyView(MockNFTImage(url: $0)) }
    }
}
