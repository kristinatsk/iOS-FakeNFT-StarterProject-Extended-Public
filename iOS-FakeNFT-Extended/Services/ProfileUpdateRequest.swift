import Foundation

struct ProfileUpdateRequest: NetworkRequest {
    let likes: [String]
    
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
        let body = "likes=\(likes.joined(separator: ","))"
        return body.data(using: .utf8)
    }
}
