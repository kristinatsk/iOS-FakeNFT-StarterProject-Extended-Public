import Foundation

struct ProfileUpdateRequest: NetworkRequest {
    let name: String?
    let description: String?
    let website: String?
    let avatar: String?
    let likes: [String]?
    
    init(
        name: String? = nil,
        description: String? = nil,
        website: String? =  nil,
        avatar: String? = nil,
        likes: [String]? = nil
    ) {
        self.name = name
        self.description = description
        self.website = website
        self.avatar = avatar
        self.likes = likes
    }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    
    var httpMethod: HttpMethod {
        .put
    }
    
    var contentType: String? {
        "application/x-www-form-urlencoded"
    }
    
    var httpBody: Data? {
        var queryItems: [URLQueryItem] = []
        
        if let name {
            queryItems.append(URLQueryItem(name: "name", value: name))
        }
        
        if let description {
            queryItems.append(URLQueryItem(name: "description", value: description))
        }
        
        if let website {
            queryItems.append(URLQueryItem(name: "website", value: website))
        }
        
        if let avatar {
            queryItems.append(URLQueryItem(name: "avatar", value: avatar))
        }
        
        if let likes {
            queryItems.append(
                URLQueryItem(
                    name: "likes",
                    value: likes.joined(separator: ",")
                )
            )
        }
        
        var components = URLComponents()
        components.queryItems = queryItems
        
        return components.percentEncodedQuery?.data(using: .utf8)
    }
}
