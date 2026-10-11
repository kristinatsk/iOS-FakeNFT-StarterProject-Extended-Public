import Observation

@MainActor
@Observable
final class ProfileViewModel {
    private let profileService: ProfileServiceProtocol
    init(profileService: ProfileServiceProtocol) {
        self.profileService = profileService
    }
    
    var name = ""
    var description = ""
    var website = ""
    var avatar = ""
    var isLoading = false
    var errorMessage: String?
    var nfts: [String] = []
    var likes: [String] = []
    
    func fetchProfile() async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }
        do {
            let profile = try await profileService.fetchProfile()
            name = profile.name
            description = profile.description
            website = profile.website
            avatar = profile.avatar
            nfts = profile.nfts
            likes = profile.likes
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
