//
//  TopTabBar.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 22/4/25.
//

import SwiftUI

struct TopTabBar: View {
    @Binding var selectedTab: ProfileTab
    private let tabs = ProfileTab.allCases

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                ForEach(tabs, id: \.self) { tab in
                    Button(action: {
                        withAnimation(.easeInOut) {
                            selectedTab = tab
                        }
                    }) {
                        Text(tab.rawValue)
                            .foregroundColor(selectedTab == tab ? .black : .gray)
                            .fontWeight(selectedTab == tab ? .bold : .regular)
                            .frame(maxWidth: .infinity)
                    }
                }
            }

            UnderlineSlider(
                selectedIndex: tabs.firstIndex(of: selectedTab) ?? 0,
                count: tabs.count
            )
            .padding(.top, 4)
        }
        .padding(.horizontal)
    }
}


struct UnderlineSlider: View {
    let selectedIndex: Int
    let count: Int

    var body: some View {
        GeometryReader { geo in
            let tabWidth = geo.size.width / CGFloat(count)

            Capsule()
                .fill(Color.black)
                .frame(width: tabWidth * 0.6, height: 2)
                .offset(x: CGFloat(selectedIndex) * tabWidth + (tabWidth * 0.2), y: 0)
                .animation(.easeInOut(duration: 0.25), value: selectedIndex)
        }
        .frame(height: 2)
    }
}


