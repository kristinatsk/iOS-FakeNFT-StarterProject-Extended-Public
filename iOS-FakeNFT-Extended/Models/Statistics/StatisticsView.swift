//
//  StatisticsView.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Урсан on 26.09.2026.
//

import SwiftUI

struct StatisticsView: View {
    
    @StateObject private var viewModel: StatisticsViewModel
    @State private var isSortSheetPresented = false
    
    init(viewModel: StatisticsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    userList
                }
            }
            .navigationTitle("Статистика")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isSortSheetPresented = true
                    } label: {
                        Image("statisticSort")
                    }
                }
            }
            .sheet(isPresented: $isSortSheetPresented) {
                sortSheet
                    .presentationDetents([.height(180)])
            }
            .alert(
                "Ошибка",
                isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { if !$0 { viewModel.errorMessage = nil } }
                )
            ) {
                Button("ОК") {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .onAppear {
                viewModel.viewDidLoad()
            }
        }
    }
    
    private var userList: some View {
        List {
            ForEach(
                Array(viewModel.users.enumerated()),
                id: \.element.id
            ) { index, user in
                
                StatisticsUserRow(
                    place: index + 1,
                    user: user
                )
                .listRowInsets(
                    EdgeInsets(
                        top: 4,
                        leading: 16,
                        bottom: 4,
                        trailing: 16
                    )
                )
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
    }
    
    private var sortSheet: some View {
        VStack(spacing: 0) {
            Text("Сортировка")
                .font(.headline)
                .padding(.top, 20)
                .padding(.bottom, 16)
            
            Button {
                viewModel.sort(by: .name)
                isSortSheetPresented = false
            } label: {
                HStack {
                    Text("По имени")
                    
                    Spacer()
                    
                    if viewModel.sortOption == .name {
                        Image(systemName: "checkmark")
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            
            Button {
                viewModel.sort(by: .rating)
                isSortSheetPresented = false
            } label: {
                HStack {
                    Text("По рейтингу")
                    
                    Spacer()
                    
                    if viewModel.sortOption == .rating {
                        Image(systemName: "checkmark")
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
        }
    }
}
