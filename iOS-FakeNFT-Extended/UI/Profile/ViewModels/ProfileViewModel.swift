import Observation

@MainActor
@Observable
final class ProfileViewModel {
    var name = "Joaquin Phoenix"
    var description = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям."
    var website = "Joaquin Phoenix.com"
}
