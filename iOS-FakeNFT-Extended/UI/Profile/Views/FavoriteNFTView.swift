import SwiftUI

struct FavoriteNFTView: View {
    let favoriteIDs: [String]
    let nftService: NftService
    let onLikesUpdated: ([String]) -> Void
    
    @State private var viewModel: FavoriteNFTViewModel
    
    init(
        favoriteIDs: [String],
        profileService: ProfileServiceProtocol,
        nftService: NftService,
        onLikesUpdated: @escaping ([String]) -> Void
    ) {
        self.favoriteIDs = favoriteIDs
        self.nftService = nftService
        self.onLikesUpdated = onLikesUpdated
        
        _viewModel = State(
            initialValue: FavoriteNFTViewModel(
                nftService: nftService,
                profileService: profileService,
                favoriteIDs: favoriteIDs
            )
        )
    }
    
    let columns = [
        GridItem(.flexible(), spacing: 7),
        GridItem(.flexible())
    ]
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if viewModel.nfts.isEmpty {
                VStack{
                    Spacer()
                    
                    Text("У вас еще нет избранных NFT")
                        .font(Font(UIFont.bodyBold))
                    
                    Spacer()
                }
                .navigationTitle("Избранные NFT")
                .navigationBarTitleDisplayMode(.inline)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.nfts, id: \.id) { item in
                            HStack(spacing: 12) {
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
                                    .frame(width: 80, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .overlay(alignment: .topTrailing) {
                                        Button {
                                            Task {
                                                if let updatedLikes = await viewModel.removeNFT(id: item.id) {
                                                    onLikesUpdated(updatedLikes)
                                                }
                                            }
                                        } label: {
                                            Image(systemName: "heart.fill")
                                                .foregroundStyle(.red)
                                                .padding(8)
                                        }
                                    }
                                } else {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 80, height: 80)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.name)
                                        .font(Font(UIFont.bodyBold))
                                    
                                    
                                    HStack(spacing: 0) {
                                        ForEach(0..<5, id: \.self) { index in
                                            Image(systemName: index < item.rating ? "star.fill" : "star")
                                                .foregroundStyle(index < item.rating ? .yellow : .gray)
                                        }
                                        .font(.system(size: 12))
                                    }
                                    
                                    Text("\(item.price, specifier: "%.2f") ETH")
                                    
                                }
                            }
                        }
                        
                        
                    }
                    .padding(.horizontal, 16)
                    .navigationTitle("Избранные NFT")
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
        
        .task {
            await viewModel.loadNFTs()
        }
    }
}



