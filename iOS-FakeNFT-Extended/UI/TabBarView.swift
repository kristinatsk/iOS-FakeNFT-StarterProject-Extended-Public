import SwiftUI

struct TabBarView: View {
    @Environment(ServicesAssembly.self) private var servicesAssembly

    var body: some View {
        TabView {
            TestCatalogView()
                .tabItem {
                    Label(
                        "Tab.catalog",
                        systemImage: "square.stack.3d.up.fill"
                    )
                }
                .backgroundStyle(.background)

            CartView(viewModel: CartViewModel(
                cartService: servicesAssembly.cartService,
                nftService: servicesAssembly.nftService
            ))
            .tabItem {
                Label(
                    "Tab.cart",
                    image: "cart"
                )
            }
        }
    }
}
