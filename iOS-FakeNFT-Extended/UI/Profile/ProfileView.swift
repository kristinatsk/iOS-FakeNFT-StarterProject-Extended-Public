import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                
                HStack(spacing: 16) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.gray)
                    
                    Text("Joaquin Phoenix")
                        .font(Font(UIFont.headline3))
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.")
                        .font(Font(UIFont.caption2))
                        .padding(.horizontal)
                    
                    Button(action: {
                        
                    }) {
                        Text("Joaquin Phoenix.com")
                    }
                    .font(Font(UIFont.caption1))
                    .padding(.horizontal, 16)
                }
                
                List {
                    NavigationLink("Мои NFT (112)", destination: Text("Экран Мои NFT"))
                    NavigationLink("Избранные NFT (11)", destination: Text("Экран Избранные NFT"))
                    
                }
                .listStyle(.plain)
                .font(Font(UIFont.bodyBold))
                .padding(.top, 40)
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
