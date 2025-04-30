//
//  ProfileView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @State private var selectedTab: ProfileTab = .lists
    @State private var selectedList: PhotoList? = nil

    var body: some View {
        NavigationStack {
            VStack {
                TopTabBar(selectedTab: $selectedTab)

                switch selectedTab {
                case .myPhotos:
                    MyPhotosView()
                case .lists:
                    ListsView(selectedList: $selectedList)
                case .likes:
                    FavsView()
                }
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 36, height: 36)

                        Image(systemName: "person")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                            .foregroundColor(.black)
                    }
                }
            }
            .navigationDestination(item: $selectedList) { list in
                MyPhotosView()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .navigateToMyPhotos)) { _ in
            selectedTab = .myPhotos
        }
    }
}


