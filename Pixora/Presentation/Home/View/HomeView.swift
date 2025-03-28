//
//  HomeView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    @StateObject var homeViewModel = Resolver.shared.resolve(HomeViewModel.self)
    
    let categories = [
        "popular",
        "nature",
        "people",
        "animals",
        "technology",
        "travel"
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                categorySelectionView()
                categoryView(for: homeViewModel.selectedCategory)
            }
        }
    }
    
    private func categoryView(for category: String) -> some View {
        ScrollView {
            VStack {
                ZStack {
                    switch homeViewModel.state {
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
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            homeViewModel.updateCategory(category) // Cargar imágenes al cambiar de categoría
        }
    }
    
    private func loadingView() -> some View {
        ProgressView()
    }
    
    private func successView() -> some View {
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth / 2) - 24
        
        let leftColumn = homeViewModel.photos.enumerated().filter { $0.offset % 2 == 0 }.map { $0.element }
        let rightColumn = homeViewModel.photos.enumerated().filter { $0.offset % 2 != 0 }.map { $0.element }
        
        return ScrollView {
            HStack(alignment: .top, spacing: 16) {
                LazyVStack(spacing: 16) {
                    ForEach(leftColumn, id: \.id) { photo in
                        NavigationLink(destination: PhotoDetailsView(photo: photo).toolbar(.hidden, for: .tabBar)) {
                            WebImage(url: photo.imageURL)
                                .resizable()
                                .scaledToFill()
                                .frame(
                                    width: itemWidth,
                                    height: CGFloat.random(in: 150...300) // Altura variable
                                )
                                .clipped()
                                .cornerRadius(8)
                        }
                    }
                }
                
                LazyVStack(spacing: 16) {
                    ForEach(rightColumn, id: \.id) { photo in
                        NavigationLink(destination: PhotoDetailsView(photo: photo).toolbar(.hidden, for: .tabBar)) {
                            WebImage(url: photo.imageURL)
                                .resizable()
                                .scaledToFill()
                                .frame(
                                    width: itemWidth,
                                    height: CGFloat.random(in: 150...300) // Altura variable
                                )
                                .clipped()
                                .cornerRadius(8)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 16)
        }
    }
    
    private func emptyView() -> some View {
        InfoView(message: "No data found")
    }
    
    private func errorView(errorMsg: String) -> some View {
        InfoView(message: errorMsg)
    }
    
    private func categorySelectionView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        homeViewModel.updateCategory(category)
                    }) {
                        Text(category.capitalized)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(
                                homeViewModel.selectedCategory == category ? Color.blue : Color.gray.opacity(0.2)
                            )
                            .foregroundColor(
                                homeViewModel.selectedCategory == category ? .white : .black
                            )
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
