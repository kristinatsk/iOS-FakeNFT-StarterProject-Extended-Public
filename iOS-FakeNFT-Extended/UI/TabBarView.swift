import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
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
                    "Статистика",
                    systemImage: "chart.bar.fill"
                )
            }
        }
    }
}
