//
//  CustomTabBar.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 30/4/25.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack {
            tabItem(icon: "house", index: 0)
            tabItem(icon: "magnifyingglass", index: 1)
            tabItem(icon: "plus", index: 2)
            tabItem(icon: "bell", index: 3)
            tabItem(icon: "person", index: 4)
        }
        .padding()
        .frame(maxWidth: 360)
        .background(Color(.systemGray5).opacity(0.9))
        .cornerRadius(20)
        .padding(.horizontal)
        .shadow(radius: 5)
    }

    func tabItem(icon: String, index: Int) -> some View {
        Button {
            selectedTab = index
        } label: {
            if selectedTab == index {
                LinearGradient.mainBluePurple
                    .mask(
                        Image(systemName: icon)
                            .resizable()
                            .scaledToFit()
                            .bold()
                            .frame(width: 24, height: 24)
                    )
                    .frame(width: 24, height: 24) // ← importante para evitar que se expanda
            } else {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .bold()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
    }

}
