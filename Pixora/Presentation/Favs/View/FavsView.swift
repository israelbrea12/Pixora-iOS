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
            .navigationTitle("Favorites")
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
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth / 3) - 20 // Ajuste para padding y spacing

        // Dividir las fotos en 3 columnas según su posición
        let columns = (0..<3).map { columnIndex in
            favsViewModel.photos.enumerated()
                .filter { $0.offset % 3 == columnIndex }
                .map { $0.element }
        }

        return ScrollView {
            HStack(alignment: .top, spacing: 12) {
                ForEach(0..<3, id: \.self) { columnIndex in
                    LazyVStack(spacing: 12) {
                        ForEach(columns[columnIndex], id: \.id) { photo in
                            NavigationLink(destination: PhotoDetailsView(photo: photo).toolbar(.hidden, for: .tabBar)) {
                                let height = CGFloat.random(in: 150...190)

                                WebImage(url: photo.imageURL) { phase in
                                    switch phase {
                                    case .empty:
                                        ZStack {
                                            Rectangle()
                                                .fill(Color.gray.opacity(0.1))
                                            ProgressView()
                                        }
                                        .frame(width: itemWidth, height: height)
                                        .cornerRadius(8)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: itemWidth, height: height)
                                            .clipped()
                                            .cornerRadius(8)
                                    case .failure:
                                        ZStack {
                                            Rectangle()
                                                .fill(Color.red.opacity(0.1))
                                            Image(systemName: "xmark.octagon")
                                                .foregroundColor(.red)
                                        }
                                        .frame(width: itemWidth, height: height)
                                        .cornerRadius(8)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 16)
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
