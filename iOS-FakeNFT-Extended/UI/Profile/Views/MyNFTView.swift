import SwiftUI

struct MyNFTView: View {
    let nftIDs: [String]
    let favoriteIDs: [String]
    let nftService: NftService
    
    @State private var viewModel: MyNFTViewModel
    @State private var isShowingSortMenu = false
    
    init(
        nftIDs: [String],
        favoriteIDs: [String],
        nftService: NftService
    ) {
        self.nftIDs = nftIDs
        self.favoriteIDs = favoriteIDs
        self.nftService = nftService
        
        _viewModel = State(
            initialValue: MyNFTViewModel(
                nftService: nftService,
                nftIDs: nftIDs
            )
        )
    }
    
    @AppStorage("myNFT.sortOption")
    private var selectedSortOption = MyNFTSortOption.rating.rawValue
    private var selectedSortOptionValue: MyNFTSortOption {
        MyNFTSortOption(rawValue: selectedSortOption) ?? .rating
    }
    private var sortedNFTs: [Nft] {
        switch selectedSortOptionValue {
        case .price:
            viewModel.nfts.sorted { $0.price < $1.price }
        case .rating:
            viewModel.nfts.sorted { $0.rating > $1.rating }
        case .name:
            viewModel.nfts.sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        }
    }
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.nfts.isEmpty {
                VStack {
                    Spacer()
                    
                    Text("У вас еще нет NFT")
                        .font(Font(UIFont.bodyBold))
                    
                    Spacer()
                }
                .navigationTitle("Мои NFT")
                .navigationBarTitleDisplayMode(.inline)
            } else {
                List {
                    ForEach(sortedNFTs, id: \.id) { item in
                        HStack(spacing: 16) {
                            if let image = item.images.first,
                            let imageURL = URL(string: image) {
                                AsyncImage(url: imageURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.2))
                                }
                                .frame(width: 108, height: 108)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(alignment: .topTrailing) {
                                    Image(
                                        systemName: favoriteIDs.contains(item.id)
                                        ? "heart.fill"
                                        : "heart"
                                    )
                                    .foregroundStyle(.white)
                                    .padding(8)
                                }
                            } else {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 108, height: 108)
                            }
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.name)
                                    .font(Font(UIFont.bodyBold))
                                
                                HStack(spacing: 0) {
                                    ForEach(0..<5, id: \.self) { index in
                                        Image(systemName: index < item.rating ? "star.fill" : "star")
                                            .foregroundStyle(index < item.rating ? .yellow : .gray)
                                    }
                                }
                                .font(.system(size: 12))
                                
                                Text(item.author)
                                    .font(Font(UIFont.caption2))
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.trailing, 39)
                            
                            
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Цена")
                                    .font(Font(UIFont.caption2))
                                
                                Text("\(item.price, specifier: "%.2f") ETH")
                                    .font(Font(UIFont.bodyBold))
                            }
                        }
                        .listRowInsets(
                            EdgeInsets(
                                top: 16,
                                leading: 16,
                                bottom: 16,
                                trailing: 16
                            )
                        )
                        .listRowSeparator(.hidden)
                        
                        
                    }
                }
                .navigationTitle("Мои NFT")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isShowingSortMenu = true
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease")
                        }
                    }
                }
                
                .listStyle(.plain)
                .confirmationDialog(
                    "Сортировка",
                    isPresented: $isShowingSortMenu) {
                        Button("По цене") {
                            selectedSortOption = MyNFTSortOption.price.rawValue
                        }
                        
                        Button("По рейтингу") {
                            selectedSortOption = MyNFTSortOption.rating.rawValue
                        }
                        
                        Button("По названию") {
                            selectedSortOption = MyNFTSortOption.name.rawValue
                        }
                        
                        Button("Закрыть", role: .cancel) { }
                    }
            }
        }
        .task {
            await viewModel.loadNFTs()
            
        }
    }
}
