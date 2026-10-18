import SwiftUI

struct TabBarView: View {

    @Environment(ServicesAssembly.self) private var servicesAssembly

    var body: some View {
        TabView {
            ProfileView(
                profileService: servicesAssembly.profileService,
                nftService: servicesAssembly.nftService
            )
                .tabItem {
                    Label(
                        NSLocalizedString("Tab.profile", comment: ""),
                        systemImage: "person.crop.circle.fill"
                    )
                }
                .backgroundStyle(.background)
            
            TestCatalogView()
                .tabItem {
                    Label(
                        NSLocalizedString(
                            "Tab.catalog",
                            comment: ""
                        ),
                        systemImage: "square.stack.3d.up.fill"
                    )
                }
                .backgroundStyle(.background)

            StatisticsView(
                viewModel: StatisticsViewModel()
            )
            .tabItem {
                Label(
                    NSLocalizedString(
                        "Tab.statistics",
                        comment: ""
                    ),
                    systemImage: "chart.bar.fill"
                )
            }

            CartView(
                viewModel: CartViewModel(
                    cartService: servicesAssembly.cartService,
                    nftService: servicesAssembly.nftService
                ),
                currenciesService: servicesAssembly.currenciesService,
                paymentService: servicesAssembly.paymentService,
                cartService: servicesAssembly.cartService
            )
            .tabItem {
                Label(
                    NSLocalizedString(
                        "Tab.cart",
                        comment: ""
                    ),
                    image: "cart"
                )
            }
        }
    }
}
