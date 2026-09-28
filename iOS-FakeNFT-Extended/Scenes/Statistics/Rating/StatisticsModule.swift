//
//  StatisticsModule.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Урсан on 26.09.2026.
//

import SwiftUI

enum StatisticsModule {
    
    static func makeRoot(servicesAssembly: ServicesAssembly) -> some View {
        let viewModel = StatisticsViewModel(
            service: servicesAssembly.statisticsService
        )
        
        return StatisticsView(viewModel: viewModel)
    }
}
