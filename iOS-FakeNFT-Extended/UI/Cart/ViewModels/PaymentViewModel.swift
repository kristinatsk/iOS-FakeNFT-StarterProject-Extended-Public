//
//  PaymentViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов на 07.10.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class PaymentViewModel {
    enum State: Equatable {
        case idle
        case loading
        case success
        case error
    }

    private(set) var state: State = .idle

    private(set) var currencies: [Currency] = []
    private(set) var selectedCurrencyID: String?
    private(set) var isLoadingCurrencies = false
    private(set) var currenciesError: String?

    private let paymentService: PaymentService
    private let cartService: CartService
    private let currenciesService: CurrenciesService
    private let orderId: String
    private let nftIDs: [String]

    private var isCheckoutDone = false

    init(
        paymentService: PaymentService,
        cartService: CartService,
        currenciesService: CurrenciesService,
        orderId: String = "1",
        nftIDs: [String]
    ) {
        self.paymentService = paymentService
        self.cartService = cartService
        self.currenciesService = currenciesService
        self.orderId = orderId
        self.nftIDs = nftIDs
    }

    var isLoading: Bool { state == .loading }

    var selectedCurrency: Currency? {
        currencies.first { $0.id == selectedCurrencyID }
    }

    var isInitialLoading: Bool { isLoadingCurrencies && currencies.isEmpty }

    func selectCurrency(id: String) {
        selectedCurrencyID = id
    }

    func loadCurrencies() async {
        guard !isLoadingCurrencies else { return }
        isLoadingCurrencies = true
        defer { isLoadingCurrencies = false }

        do {
            currencies = try await currenciesService.loadCurrencies()
            currenciesError = nil
        } catch {
            currenciesError = String(localized: "Error.network")
        }
    }

    func pay(currencyId: String) async {
        guard state != .loading else { return }
        state = .loading

        if !isCheckoutDone {
            do {
                try await paymentService.setCurrency(orderId: orderId, currencyId: currencyId)
                try await paymentService.checkout(orderId: orderId, nftIDs: nftIDs)
            } catch {
                state = .error
                return
            }
            isCheckoutDone = true
        }

        do {
            try await cartService.clearCart(id: orderId)
        } catch {
            state = .error
            return
        }

        state = .success
    }

    func retry(currencyId: String) async {
        await pay(currencyId: currencyId)
    }

    func cancel() {
        guard state != .loading else { return }
        state = .idle
    }
}

// MARK: - Mocks

extension PaymentViewModel {
    static func mock(shouldFailCheckout: Bool = false) -> PaymentViewModel {
        PaymentViewModel(
            paymentService: MockPaymentService(shouldFailCheckout: shouldFailCheckout),
            cartService: MockCartService(),
            currenciesService: MockCurrenciesService(),
            nftIDs: CartItemCellModel.mocks.map(\.id)
        )
    }
}
