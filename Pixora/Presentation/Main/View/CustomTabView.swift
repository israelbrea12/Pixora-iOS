//
//  CustomTabView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 30/4/25.
//

import SwiftUI

struct CustomTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                switch selectedTab {
                case 0: HomeView()
                case 1: SearchView()
                case 2: Color.clear // Placeholder for modal
                case 3: NotificationsView()
                case 4: ProfileView()
                default: HomeView()
                }
            }

            HStack {
                tabButton(index: 0, systemIcon: "house")
                tabButton(index: 1, systemIcon: "magnifyingglass")
                tabButton(index: 2, systemIcon: "plus", isCentral: true)
                tabButton(index: 3, systemIcon: "bell")
                tabButton(index: 4, systemIcon: "person")
            }
            .padding()
            .background(.ultraThinMaterial)
        }
    }

    @ViewBuilder
    func tabButton(index: Int, systemIcon: String, isCentral: Bool = false) -> some View {
        Button {
            selectedTab = index
        } label: {
            VStack {
                if selectedTab == index {
                    LinearGradient.mainBluePurple
                        .mask(Image(systemName: systemIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24))
                        .frame(width: 24, height: 24)
                } else {
                    Image(systemName: systemIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, isCentral ? 16 : 8)
        }
    }
}
