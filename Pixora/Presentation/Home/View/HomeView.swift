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
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        NavigationStack{
            ZStack(
                content:{
                    switch homeViewModel.state{
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
            .navigationTitle("Photos")
            .searchable(
                text: $homeViewModel.searchQuery,
                prompt: "Search photos"
            )
            .onChange(of: homeViewModel.searchDebounced, perform:{ _ in
                Task{
                    await homeViewModel.searchPhotos()
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

        let leftColumn = homeViewModel.photos.enumerated().filter { $0.offset % 2 == 0 }.map { $0.element }
        let rightColumn = homeViewModel.photos.enumerated().filter { $0.offset % 2 != 0 }.map { $0.element }

        return ScrollView {
            HStack(alignment: .top, spacing: 16) {
                LazyVStack(spacing: 16) {
                    ForEach(leftColumn, id: \.id) { photo in
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

                LazyVStack(spacing: 16) {
                    ForEach(rightColumn, id: \.id) { photo in
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

