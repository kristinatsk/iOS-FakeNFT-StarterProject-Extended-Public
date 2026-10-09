//
//  UserCardView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Урсан on 04.10.2026.
//

import SwiftUI

struct UserCardView: View {

    @StateObject private var viewModel: UserCardViewModel
    @Environment(\.dismiss) private var dismiss

    let userId: String

    init(
        userId: String,
        viewModel: UserCardViewModel
    ) {
        self.userId = userId
        _viewModel = StateObject(
            wrappedValue: viewModel
        )
    }

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Загрузка пользователя...")
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
            } else if let model = viewModel.model {
                content(model)
            } else if let errorMessage = viewModel.errorMessage {
                VStack(spacing: 12) {
                    Text("Не удалось загрузить пользователя")
                        .font(.headline)

                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    Button("Повторить") {
                        viewModel.load(userId: userId)
                    }
                }
                .padding()
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )
            } else {
                VStack(spacing: 12) {
                    Text("Данные пользователя не загружены")
                        .foregroundStyle(.secondary)

                    Button("Загрузить повторно") {
                        viewModel.load(userId: userId)
                    }
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )
            }
        }
        .navigationTitle("Пользователь")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
        }
        .onAppear {
            viewModel.load(userId: userId)
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

    private func content(
        _ model: UserCardModel
    ) -> some View {
        ScrollView {
            VStack(
                alignment: .leading,
                spacing: 16
            ) {
                HStack(spacing: 16) {
                    AsyncImage(
                        url: URL(
                            string: model.avatarURLString
                        )
                    ) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()

                        default:
                            Image("statisticAvatarTable")
                                .resizable()
                                .scaledToFill()
                        }
                    }
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())

                    Text(model.name)
                        .font(
                            .system(
                                size: 22,
                                weight: .semibold
                            )
                        )
                        .lineLimit(2)

                    Spacer()
                }

                Text(model.description)
                    .font(.system(size: 15))
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )

                Button {
                    guard let url = viewModel.websiteTapped() else {
                        return
                    }

                    UIApplication.shared.open(url)
                } label: {
                    Text("Перейти на сайт пользователя")
                        .font(
                            .system(
                                size: 15,
                                weight: .medium
                            )
                        )
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(
                                    .primary,
                                    lineWidth: 1
                                )
                        }
                }

                NavigationLink {
                    UserCollectionModule.make(
                        userId: userId
                    )
                } label: {
                    HStack {
                        Text(
                            "Коллекция NFT (\(model.nftCount))"
                        )
                        .font(
                            .system(
                                size: 17,
                                weight: .semibold
                            )
                        )

                        Spacer()

                        Image(systemName: "chevron.right")
                            .foregroundStyle(.tertiary)
                    }
                    .frame(height: 54)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 20)
        }
    }
}
