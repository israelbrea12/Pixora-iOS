//
//  ProfileView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = Resolver.shared.resolve(ProfileViewModel.self)

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.state {
                case .initial, .loading:
                    ProgressView()

                case .success:
                    SuccessView()

                case .empty:
                    InfoView(message: "No tienes listas todavía.")

                case .error(let msg):
                    InfoView(message: msg)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.2)) // Gris mucho más claro
                            .frame(width: 36, height: 36)

                        Image(systemName: "person")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18) // Tamaño ajustado
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .task {
            await viewModel.loadLists()
        }
    }
    
    func SuccessView() -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.listsWithPhotos, id: \.0.id) { (list, photos) in
                    NavigationLink(destination: PhotoListDetailView(photoList: list)) {
                        PhotoListCardView(photoList: list, photos: photos)
                    }
                }
            }
            .padding()
        }
    }
}

