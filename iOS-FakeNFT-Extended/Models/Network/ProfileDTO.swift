import Foundation

struct ProfileDTO: Decodable, Sendable {
    /// Уникальный идентификатор пользователя.
    let id: String
    
    /// Отображаемое имя пользователя.
    let name: String
    
    /// Описание профиля.
    let description: String
    
    /// Ссылка на сайт пользователя.
    let website: String
    
    /// URL изображения профиля.
    let avatar: String
    
    /// Идентификаторы NFT, принадлежащих пользователю.
    let nfts: [String]
    
    /// Идентификаторы NFT, добавленных пользователем в избранное.
    let likes: [String]
}
