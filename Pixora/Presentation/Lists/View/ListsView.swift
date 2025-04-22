//
//  ListsView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 22/4/25.
//

import SwiftUI

struct ListsView: View {
    @StateObject private var viewModel = Resolver.shared.resolve(ListsViewModel.self)
    @Binding var selectedList: PhotoList?

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ZStack {
            switch viewModel.state {
            case .initial, .loading:
                ProgressView()
            case .success:
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.listsWithPhotos, id: \.0.id) { (list, photos) in
                            Button {
                                selectedList = list
                            } label: {
                                PhotoListCardView(photoList: list, photos: photos)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            case .empty:
                InfoView(message: "No tienes listas todavía.")
            case .error(let msg):
                InfoView(message: msg)
            }
        }
        .task {
            await viewModel.loadListsIfNeeded()
        }
    }
}
