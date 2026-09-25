import SwiftUI

struct MockNFT: Identifiable {
    let id = UUID()
    let name: String
    let author: String
    let price: String
    let rating: Double
    let isFavorite: Bool
    let imageName: String
}

struct MyNFTView: View {
    let nft: [MockNFT] = [
        MockNFT(
            name: "Lilo",
            author: "от John Doe",
            price: "1,78 ETH",
            rating: 3.0,
            isFavorite: false,
            imageName: ""
        ),
        MockNFT(
            name: "Spring",
            author: "от John Doe",
            price: "1,78 ETH",
            rating: 3.0,
            isFavorite: false,
            imageName: ""
        ),
        MockNFT(
            name: "April",
            author: "от John Doe",
            price: "1,78 ETH",
            rating: 3.0,
            isFavorite: true,
            imageName: ""
        )
    ]
    @State private var isShowingSortMenu = false
    var body: some View {
        if nft.isEmpty {
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
                ForEach(nft) { item in
                    HStack(spacing: 16) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 108, height: 108)
                            .overlay(alignment: .topTrailing) {
                                Image(systemName: item.isFavorite ? "heart.fill" : "heart")
                                    .foregroundStyle(.white)
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
                            
                            Text(item.price)
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
                        
                    }
                    
                    Button("По рейтингу") {
                        
                    }
                    
                    Button("По названию") {
                        
                    }
                    
                    Button("Закрыть", role: .cancel) {
                        
                    }
                }
        }
    }
}

#Preview {
    MyNFTView()
}
