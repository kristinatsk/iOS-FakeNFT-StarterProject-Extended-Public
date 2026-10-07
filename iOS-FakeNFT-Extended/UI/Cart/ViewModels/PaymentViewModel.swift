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

    private let paymentService: PaymentService
    private let cartService: CartService
    private let orderId: String
    private let nftIDs: [String]

    private var isCheckoutDone = false

    init(
        paymentService: PaymentService,
        cartService: CartService,
        orderId: String = "1",
        nftIDs: [String]
    ) {
        self.paymentService = paymentService
        self.cartService = cartService
        self.orderId = orderId
        self.nftIDs = nftIDs
    }

    var isLoading: Bool { state == .loading }

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
            nftIDs: CartItemCellModel.mocks.map(\.id)
        )
    }
}
