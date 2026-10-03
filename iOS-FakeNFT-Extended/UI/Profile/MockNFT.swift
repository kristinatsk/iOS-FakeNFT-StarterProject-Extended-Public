import Foundation

struct MockNFT: Identifiable {
    let id = UUID()
    let name: String
    let author: String
    let price: String
    let rating: Double
    let isFavorite: Bool
    let imageName: String
}

let mockMyNFTs: [MockNFT] = [
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
        isFavorite: false,
        imageName: ""
    )
]

let mockFavoriteNFTs: [MockNFT] = [
    MockNFT(
        name: "Lilo",
        author: "от John Doe",
        price: "1,78 ETH",
        rating: 4.0,
        isFavorite: true,
        imageName: ""
    ),
    MockNFT(
        name: "April",
        author: "от John Doe",
        price: "1,78 ETH",
        rating: 2.0,
        isFavorite: true,
        imageName: ""
    ),
    MockNFT(
        name: "Archie",
        author: "от John Doe",
        price: "1,78 ETH",
        rating: 1.0,
        isFavorite: true,
        imageName: ""
    ),
    MockNFT(
        name: "Pixi",
        author: "от John Doe",
        price: "1,78 ETH",
        rating: 3.0,
        isFavorite: true,
        imageName: ""
    ),
    MockNFT(
        name: "Melissa",
        author: "от John Doe",
        price: "1,78 ETH",
        rating: 5.0,
        isFavorite: true,
        imageName: ""
    ),
    MockNFT(
        name: "Daisy",
        author: "от John Doe",
        price: "1,78 ETH",
        rating: 1.0,
        isFavorite: true,
        imageName: ""
    ),
]
