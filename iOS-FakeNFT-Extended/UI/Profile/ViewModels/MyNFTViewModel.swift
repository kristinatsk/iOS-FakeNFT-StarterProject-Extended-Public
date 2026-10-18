import Observation

@MainActor
@Observable
final class MyNFTViewModel {
    private let nftService: NftService
    private let nftIDs: [String]
    
    var nfts: [Nft] = []
    var isLoading = false
    var errorMessage: String?
    
    
    init(
        nftService: NftService,
        nftIDs: [String]
    ) {
        self.nftService = nftService
        self.nftIDs = nftIDs
    }
    
    func loadNFTs() async {
        errorMessage = nil
        isLoading = true
        nfts = []
        defer { isLoading = false }
        for id in nftIDs {
            do {
                let nft = try await nftService.loadNft(id: id)
                nfts.append(nft)
            } catch {
                print("Failed to load NFT \(id): \(error)")
            }
        }
        
        if nfts.isEmpty && !nftIDs.isEmpty {
            errorMessage = "Не удалось загрузить NFT"
        }
        
    }
}
