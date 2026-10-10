import Foundation

struct Nft: Decodable, Sendable {
    let id: String
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let author: String
    let website: String
}
