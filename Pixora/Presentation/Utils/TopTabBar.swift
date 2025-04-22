//
//  TopTabBar.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 22/4/25.
//

import SwiftUI

struct TopTabBar: View {
    @Binding var selectedTab: ProfileTab

    var body: some View {
        HStack {
            ForEach(ProfileTab.allCases, id: \.self) { tab in
                Button(action: {
                    selectedTab = tab
                }) {
                    VStack {
                        Text(tab.rawValue)
                            .foregroundColor(selectedTab == tab ? .black : .gray)
                            .fontWeight(selectedTab == tab ? .bold : .regular)
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(selectedTab == tab ? .black : .clear)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
    }
}
