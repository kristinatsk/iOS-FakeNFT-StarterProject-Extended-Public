import Foundation

struct Nft: Decodable, Sendable {
    let id: String
    let name: String
    let images: [URL]
    let price: Double
    let rating: Int
    let author: String
}
