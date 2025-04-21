//
//  PhotoListDetailView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 21/4/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct PhotoListDetailView: View {
    @StateObject var photoListDetailViewModel: PhotoListDetailViewModel
    @EnvironmentObject private var tabBarVisibility: TabBarVisibilityManager
    
    init(photoList: PhotoList) {
        _photoListDetailViewModel = StateObject(
            wrappedValue: Resolver.shared
                .resolve(PhotoListDetailViewModel.self, argument: photoList)
        )
    }

    var body: some View {
        ZStack {
            switch photoListDetailViewModel.state {
            case .initial, .loading:
                ProgressView()

            case .success:
                contentView()

            case .empty:
                InfoView(message: "Esta lista no tiene fotos.")

            case .error(let message):
                InfoView(message: message)
            }
        }
        .navigationTitle(photoListDetailViewModel.list.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await photoListDetailViewModel.loadPhotos()
        }
        .onAppear {
            tabBarVisibility.isVisible = false
        }
        .onDisappear {
            tabBarVisibility.isVisible = true
        }
    }

    @ViewBuilder
    private func contentView() -> some View {
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth / 2) - 24

        let leftColumn = photoListDetailViewModel.photos.enumerated().filter { $0.offset % 2 == 0 }.map {
            $0.element
        }
        let rightColumn = photoListDetailViewModel.photos.enumerated().filter { $0.offset % 2 != 0 }.map {
            $0.element
        }

        ScrollView {
            HStack(alignment: .top, spacing: 16) {
                LazyVStack(spacing: 16) {
                    ForEach(leftColumn, id: \.id) { photo in
                        NavigationLink(
                            destination: PhotoDetailsView(photo: photo)
                        ) {
                            photoCard(photo: photo, width: itemWidth)
                        }
                    }
                }

                LazyVStack(spacing: 16) {
                    ForEach(rightColumn, id: \.id) { photo in
                        NavigationLink(
                            destination: PhotoDetailsView(photo: photo)
                        ) {
                            photoCard(photo: photo, width: itemWidth)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 16)
        }
    }

    private func photoCard(photo: Photo, width: CGFloat) -> some View {
        let height = CGFloat.random(in: 150...300)

        return WebImage(url: photo.imageURL) { phase in
            switch phase {
            case .empty:
                ZStack {
                    Rectangle().fill(Color.gray.opacity(0.1))
                    ProgressView()
                }

            case .success(let image):
                image.resizable()
                    .scaledToFill()
                    .clipped()

            case .failure:
                ZStack {
                    Rectangle().fill(Color.red.opacity(0.1))
                    Image(systemName: "xmark.octagon")
                        .foregroundColor(.red)
                }

            @unknown default:
                EmptyView()
            }
        }
        .frame(width: width, height: height)
        .cornerRadius(8)
    }
}

