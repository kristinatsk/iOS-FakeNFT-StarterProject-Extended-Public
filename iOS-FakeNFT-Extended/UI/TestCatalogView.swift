import SwiftUI

struct TestCatalogView: View {
    @Environment(ServicesAssembly.self) var servicesAssembly
    @State private var presentingNft = false

    var body: some View {
        Button {
            showNft()
        } label: {
            Text("Catalog.openNft")
                .tint(.blue)
        }
        .backgroundStyle(.background)
        .sheet(isPresented: $presentingNft) {
            NftDetailBridgeView()
        }
    }

    func showNft() {
        presentingNft = true
    }
}
