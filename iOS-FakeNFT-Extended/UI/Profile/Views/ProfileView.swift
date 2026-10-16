import SwiftUI

struct ProfileView: View {
    let profileService: ProfileServiceProtocol
    let nftService: NftService
    
    @State private var isShowingSafari = false
    @State private var viewModel: ProfileViewModel
    
    init(
        profileService: ProfileServiceProtocol,
        nftService: NftService
    ) {
        self.profileService = profileService
        self.nftService = nftService
        
        _viewModel = State(
            initialValue: ProfileViewModel(
                profileService: profileService
            )
        )
        
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                
                HStack(spacing: 16) {
                    if let avatarURL = URL(string: viewModel.avatar),
                       !viewModel.avatar.isEmpty {
                        AsyncImage(url: avatarURL) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .foregroundColor(.gray)
                            
                        }
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.gray)
                    }
                    
                    Text(viewModel.name)
                        .font(Font(UIFont.headline3))
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.description)
                        .font(Font(UIFont.caption2))
                        .padding(.horizontal)
                    
                    Button(action: {
                        isShowingSafari = true
                    }) {
                        Text(viewModel.website)
                    }
                    .font(Font(UIFont.caption1))
                    .padding(.horizontal, 16)
                    .sheet(isPresented: $isShowingSafari) {
                        if let url = URL(string: viewModel.website) {
                            SafariView(url: url)
                        }
                    }
                }
                
                List {
                    NavigationLink(
                        "Мои NFT (\(viewModel.nfts.count))",
                        destination: MyNFTView(
                            nftIDs: viewModel.nfts,
                            favoriteIDs: viewModel.likes,
                            nftService: nftService
                        )
                    )
                    NavigationLink(
                        "Избранные NFT (\(viewModel.likes.count))",
                        destination: FavoriteNFTView(
                            favoriteIDs: viewModel.likes,
                            profileService: profileService,
                            nftService: nftService
                        ) { updatedLikes in
                            viewModel.likes = updatedLikes
                        }
                    )
                    
                }
                .listStyle(.plain)
                .font(Font(UIFont.bodyBold))
                .padding(.top, 40)
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        EditProfileView(viewModel: viewModel)
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
        .task {
            await viewModel.fetchProfile()
        }
        
    }
}

