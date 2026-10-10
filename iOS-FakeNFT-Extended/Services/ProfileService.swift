import Foundation

protocol ProfileServiceProtocol {
    func fetchProfile() async throws -> ProfileDTO
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
}
