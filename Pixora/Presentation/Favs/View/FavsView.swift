//
//  FavsView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//



import SwiftUI
import SDWebImageSwiftUI

struct FavsView: View {
    @StateObject var favsViewModel = Resolver.shared.resolve(FavsViewModel.self)
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        NavigationStack {
            ZStack {
                switch favsViewModel.state {
                case .loading:
                    loadingView()
                case .success:
                    successView()
                case .error(let errorMessage):
                    errorView(errorMsg: errorMessage)
                default:
                    emptyView()
                }
            }
            .onAppear {
                Task {
                    await favsViewModel.refreshIfNeeded()
                }
            }
        }
    }
    
    private func loadingView() -> some View {
        ProgressView()
    }
    
    private func successView() -> some View {
        let spacing: CGFloat = 12

        return GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let columnCount = screenWidth > 1000 ? 4 : 3
            let itemWidth = (screenWidth - spacing * CGFloat(columnCount + 1)) / CGFloat(columnCount)

            // Precompute the columns outside the ViewBuilder
            let columns = createColumns(from: favsViewModel.photos, columnCount: columnCount)

            ScrollView {
                HStack(alignment: .top, spacing: spacing) {
                    ForEach(0..<columnCount, id: \.self) { columnIndex in
                        LazyVStack(spacing: spacing) {
                            ForEach(columns[columnIndex], id: \.id) { photo in
                                NavigationLink(destination: PhotoDetailsView(photo: photo).toolbar(.hidden, for: .tabBar))
                                {
                                    let height = screenWidth > 700
                                        ? CGFloat.random(in: 300...500)
                                        : CGFloat.random(in: 150...190)

                                    if let data = photo.imageData, let uiImage = UIImage(data: data) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: itemWidth, height: height)
                                            .clipped()
                                            .cornerRadius(8)
                                    } else {
                                        WebImage(url: photo.imageURL) { phase in
                                            switch phase {
                                            case .empty:
                                                ZStack {
                                                    Rectangle().fill(Color.gray.opacity(0.1))
                                                    ProgressView()
                                                }
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFill()
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
                                        .frame(width: itemWidth, height: height)
                                        .clipped()
                                        .cornerRadius(8)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, spacing)
                .padding(.top, spacing)
            }
        }
    }

    private func emptyView() -> some View {
        InfoView(message: "No favorites yet")
    }
    
    private func errorView(errorMsg: String) -> some View {
        InfoView(message: errorMsg)
    }
}

#Preview {
    FavsView()
}
