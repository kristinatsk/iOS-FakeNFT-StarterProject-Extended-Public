import SwiftUI

struct FavoriteNFTView: View {
    let columns = [
        GridItem(.flexible(), spacing: 7),
        GridItem(.flexible())
    ]
    var body: some View {
        if mockFavoriteNFTs.isEmpty {
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
                ForEach(mockFavoriteNFTs) { item in
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 80, height: 80)
                            .overlay(alignment: .topTrailing) {
                                Image(systemName: "heart.fill")
                                    .foregroundStyle(.red)
                                    .padding(8)
                            }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.name)
                                .font(Font(UIFont.bodyBold))
                            
                            
                            HStack(spacing: 0) {
                                ForEach(0..<5, id: \.self) { index in
                                    Image(systemName: index < Int(item.rating) ? "star.fill" : "star")
                                        .foregroundStyle(index < Int(item.rating) ? .yellow : .gray)
                                }
                                .font(.system(size: 12))
                            }
                            
                            Text(item.price)
                            
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
}

#Preview {
    FavoriteNFTView()
}
