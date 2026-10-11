import Foundation

protocol ProfileServiceProtocol {
    func fetchProfile() async throws -> ProfileDTO
    func updateLikes(_ likes: [String]) async throws -> ProfileDTO
}

actor ProfileService: ProfileServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func fetchProfile() async throws -> ProfileDTO {
        let request = ProfileRequest()
        return try await networkClient.send(request: request)
    }
    
    func updateLikes(_ likes: [String]) async throws -> ProfileDTO {
        let request = ProfileUpdateRequest(likes: likes)
        return try await networkClient.send(request: request)
    }
}
