import SwiftUI

struct ProfileView: View {
    @State private var isShowingSafari = false
    @State private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                
                HStack(spacing: 16) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.gray)
                    
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
                        if let url = URL(string: "https://practicum.yandex.ru") {
                            SafariView(url: url)
                        }
                    }
                }
                
                List {
                    NavigationLink("Мои NFT (112)", destination: MyNFTView())
                    NavigationLink("Избранные NFT (11)", destination: FavoriteNFTView())
                    
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
        
    }
}

#Preview {
    ProfileView()
}
