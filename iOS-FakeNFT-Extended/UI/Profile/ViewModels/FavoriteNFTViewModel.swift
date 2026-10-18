import Observation

@MainActor
@Observable
final class FavoriteNFTViewModel {
    private let nftService: NftService
    private var favoriteIDs: [String]
    private let profileService: ProfileServiceProtocol
    
    var nfts: [Nft] = []
    var isLoading = false
    var errorMessage: String?
    
    init(
        nftService: NftService,
        profileService: ProfileServiceProtocol,
        favoriteIDs: [String]
    ) {
        self.nftService = nftService
        self.profileService = profileService
        self.favoriteIDs = favoriteIDs
    }
    
    func loadNFTs() async {
        errorMessage = nil
        isLoading = true
        nfts = []
        defer { isLoading = false }
        
        for id in favoriteIDs {
            do {
                let nft = try await nftService.loadNft(id: id)
                nfts.append(nft)
            } catch {
                
            }
        }
        if nfts.isEmpty && !favoriteIDs.isEmpty {
            errorMessage = "Не удалось загрузить избранные NFT"
        }
        
    }
    
    func removeNFT(id: String) async -> [String]? {
        let updatedLikes = favoriteIDs.filter { $0 != id}
        do {
            _ = try await profileService.updateLikes(updatedLikes)
            
            favoriteIDs = updatedLikes
            nfts.removeAll { $0.id == id }
            
            return updatedLikes
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
        
    }
}
