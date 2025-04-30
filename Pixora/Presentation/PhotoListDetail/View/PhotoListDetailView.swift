//
//  PhotoListDetailView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 21/4/25.
//

//
//  PhotoListDetailView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 21/4/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct PhotoListDetailView: View {
    let list: PhotoList
    
    @StateObject var photoListDetailViewModel = Resolver.shared.resolve(PhotoListDetailViewModel.self)
    
    @EnvironmentObject private var tabBarVisibility: TabBarVisibilityManager

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
        .navigationTitle(list.name)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await photoListDetailViewModel.loadPhotos(list: list)
        }
        .onAppear {
            tabBarVisibility.isVisible = false
        }
    }

    @ViewBuilder
    private func contentView() -> some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let spacing: CGFloat = 16
            let columnCount = screenWidth > 700 ? 3 : 2
            let totalSpacing = spacing * CGFloat(columnCount + 1)
            let itemWidth = max((screenWidth - totalSpacing) / CGFloat(columnCount), 0)

            let columns = createColumns(from: photoListDetailViewModel.photos, columnCount: columnCount)

            if itemWidth > 0 {
                ScrollView {
                    HStack(alignment: .top, spacing: spacing) {
                        ForEach(0..<columns.count, id: \.self) { columnIndex in
                            LazyVStack(spacing: spacing) {
                                ForEach(columns[columnIndex], id: \.id) { photo in
                                    NavigationLink(destination: PhotoDetailsView(photo: photo)) {
                                        photoCard(photo: photo, width: itemWidth)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, spacing)
                }
            } else {
                ProgressView()
            }
        }
    }

    private func photoCard(photo: Photo, width: CGFloat) -> some View {
        let safeWidth = max(width, 0)
        let height = safeWidth * CGFloat.random(in: 1.2...1.8)

        return Group {
            if let data = photo.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else if let url = photo.imageURL {
                WebImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Rectangle().fill(Color.gray.opacity(0.1))
                            ProgressView()
                        }
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .failure:
                        ZStack {
                            Rectangle().fill(Color.red.opacity(0.1))
                            Image(systemName: "xmark.octagon").foregroundColor(.red)
                        }
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Rectangle().fill(Color.gray.opacity(0.2))
            }
        }
        .frame(width: safeWidth, height: height)
        .clipped()
        .cornerRadius(8)
    }
}
