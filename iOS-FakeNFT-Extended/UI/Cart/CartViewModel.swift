//
//  CartViewModel.swift
//  iOS-FakeNFT-Extended
//
//  Created by Павел Кузнецов on 22.09.2026.
//

import Foundation

@MainActor
final class CartViewModel: ObservableObject {
    @Published private(set) var items: [CartItemCellModel] = []
    
    var isEmpty: Bool { items.isEmpty }
    var totalPrice: Double { items.map(\.price).reduce(0, +) }
    
    init(items: [CartItemCellModel] = []) {
        self.items = items
    }
    
    func remove(at index: Int) {
        guard items.indices.contains(index) else { return }
        items.remove(at: index)
        // TODO: в задаче 2.2 добавить попап подтверждения удаления
    }
    
    func remove(byId id: String) {
        guard let index = items.firstIndex(where: { $0.id == id }) else { return }
        items.remove(at: index)
    }
}

// MARK: - Mocks

extension CartViewModel {
    static func mock() -> CartViewModel {
        let viewModel = CartViewModel()
        viewModel.items = CartItemCellModel.mocks.map { model in
            CartItemCellModel(
                id: model.id,
                name: model.name,
                imageURL: model.imageURL,
                rating: model.rating,
                price: model.price,
                onDelete: { [weak viewModel] in
                    viewModel?.remove(byId: model.id)
                }
            )
        }
        return viewModel
    }
}
