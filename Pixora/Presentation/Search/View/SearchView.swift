//
//  SearchView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchView: View {
    @StateObject var searchViewModel = Resolver.shared.resolve(SearchViewModel.self)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        NavigationStack{
            ZStack(
                content:{
                    switch searchViewModel.state{
                    case .initial,
                            .loading:
                        loadingView()
                    case .success:
                        successView()
                    case .error(let errorMessage):
                        errorView(errorMsg:errorMessage)
                    default:
                        emptyView()
                    }
                }
            )
            .navigationTitle("Search")
            .searchable(
                text: $searchViewModel.searchQuery,
                prompt: "Search photos"
            )
            .onChange(of: searchViewModel.searchDebounced, perform:{ _ in
                Task{
                    await searchViewModel.searchPhotos()
                }
            })
        }
    }
    
    private func loadingView() -> some View {
        ProgressView()
    }
    
    private func successView() -> some View {
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth / 2) - 24

        let leftColumn = searchViewModel.photos.enumerated().filter { $0.offset % 2 == 0 }.map { $0.element }
        let rightColumn = searchViewModel.photos.enumerated().filter { $0.offset % 2 != 0 }.map { $0.element }

        return ScrollView {
            HStack(alignment: .top, spacing: 16) {
                LazyVStack(spacing: 16) {
                    ForEach(leftColumn, id: \.id) { photo in
                        NavigationLink(destination: PhotoDetailsView(photo: photo).toolbar(.hidden, for: .tabBar)) {
                            WebImage(url: photo.imageURL)
                                .resizable()
                                .scaledToFill()
                                .frame(width: itemWidth, height: CGFloat.random(in: 150...300))
                                .clipped()
                                .cornerRadius(8)
                        }
                        .onAppear {
                            if photo == searchViewModel.photos.last {
                                Task {
                                    await searchViewModel.fetchPhotos()
                                }
                            }
                        }
                    }
                }
                
                LazyVStack(spacing: 16) {
                    ForEach(rightColumn, id: \.id) { photo in
                        NavigationLink(destination: PhotoDetailsView(photo: photo).toolbar(.hidden, for: .tabBar)) {
                            WebImage(url: photo.imageURL)
                                .resizable()
                                .scaledToFill()
                                .frame(width: itemWidth, height: CGFloat.random(in: 150...300))
                                .clipped()
                                .cornerRadius(8)
                        }
                        .onAppear {
                            if photo == searchViewModel.photos.last {
                                Task {
                                    await searchViewModel.fetchPhotos()
                                }
                            }
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
}

#Preview {
    SearchView()
}
