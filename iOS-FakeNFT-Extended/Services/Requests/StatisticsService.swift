//
//  StatisticsService.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Урсан on 26.09.2026.
//

import SwiftUI
import UIKit

enum StatisticsModule {

    static func makeRoot(
        servicesAssembly: ServicesAssembly
    ) -> UIViewController {

        let viewModel = StatisticsViewModel()

        let view = StatisticsView(viewModel: viewModel)

        return UIHostingController(rootView: view)
    }
}
