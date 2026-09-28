//
//  StatisticsUserRow.swift
//  iOS-FakeNFT-Extended
//
//  Created by Андрей Урсан on 26.09.2026.
//

import SwiftUI

struct StatisticsUserRow: View {
    
    let place: Int
    let user: StatisticsUserDomain
    
    var body: some View {
        HStack(spacing: 12) {
            
            Text("\(place)")
                .font(.system(size: 15))
                .frame(width: 20)
            
            HStack(spacing: 8) {
                
                AsyncImage(url: URL(string: user.avatarURLString)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            
                    default:
                        Image("statisticAvatarTable")
                            .resizable()
                            .scaledToFill()
                    }
                }
                .frame(width: 28, height: 28)
                .clipShape(Circle())
                
                Text(user.name)
                    .font(.system(size: 22, weight: .bold))
                    .lineLimit(1)
                
                Spacer()
                
                Text("\(user.nftCount)")
                    .font(.system(size: 22, weight: .bold))
            }
            .padding(.horizontal, 12)
            .frame(height: 80)
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
