//
//  UserCollectionView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Урсан on 06.10.2026.
//

import SwiftUI

struct UserCollectionView: View {
    @StateObject private var viewModel: UserCollectionViewModel

    @Environment(\.dismiss)
    private var dismiss

    init(viewModel: UserCollectionViewModel) {
        _viewModel = StateObject(
            wrappedValue: viewModel
        )
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                loadingView
            } else {
                collectionView
            }
        }
        .navigationTitle("Коллекция NFT")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(
                placement: .navigationBarLeading
            ) {
                Button("Назад") {
                    dismiss()
                }
            }
        }
        .onAppear {
            viewModel.load()
        }
        .alert(
            "Ошибка",
            isPresented: Binding(
                get: {
                    viewModel.errorMessage != nil
                },
                set: { isPresented in
                    if !isPresented {
                        viewModel.errorMessage = nil
                    }
                }
            )
        ) {
            Button("ОК") {
                viewModel.errorMessage = nil
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    private var loadingView: some View {
        VStack(spacing: 12) {
            ProgressView()

            Text("Идет загрузка")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
    }

    private var collectionView: some View {
        ScrollView {
            if viewModel.items.isEmpty {
                emptyView
            } else {
                LazyVGrid(
                    columns: [
                        GridItem(
                            .flexible(),
                            spacing: 12
                        ),
                        GridItem(
                            .flexible(),
                            spacing: 12
                        ),
                        GridItem(
                            .flexible(),
                            spacing: 12
                        )
                    ],
                    spacing: 20
                ) {
                    ForEach(viewModel.items) { item in
                        UserCollectionNftCell(
                            item: item
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
        }
    }

    private var emptyView: some View {
        VStack(spacing: 8) {
            Text("Коллекция пуста")
                .font(
                    .system(
                        size: 17,
                        weight: .semibold
                    )
                )

            Text("У пользователя пока нет NFT")
                .font(.system(size: 15))
                .foregroundStyle(.secondary)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .padding(.top, 100)
    }
}
