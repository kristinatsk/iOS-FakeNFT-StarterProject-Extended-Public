import Observation

@MainActor
@Observable
final class ProfileViewModel {
    private let profileService: ProfileServiceProtocol
    init(profileService: ProfileServiceProtocol) {
        self.profileService = profileService
    }
    
    //TODO: убрать хардкорженные строки
    var name = "Joaquin Phoenix"
    var description = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."
    var website = "Joaquin Phoenix.com"
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
