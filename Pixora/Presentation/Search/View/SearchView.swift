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
        @Environment(\.verticalSizeClass) var verticalSizeClass
        
        var body: some View {
            NavigationStack {
                VStack(spacing: 0) {
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        customSearchBar()
                            .padding()
                    }
                    
                    ZStack {
                        switch searchViewModel.state {
                        case .initial, .loading:
                            loadingView()
                        case .success:
                            successView()
                        case .error(let errorMessage):
                            errorView(errorMsg: errorMessage)
                        default:
                            emptyView()
                        }
                    }
                }
                .navigationTitle("Search")
                .if(UIDevice.current.userInterfaceIdiom != .pad) { view in
                    view.searchable(
                        text: $searchViewModel.searchQuery,
                        prompt: "Search photos"
                    )
                }
                .onChange(of: searchViewModel.searchDebounced) { _ in
                    Task {
                        await searchViewModel.searchPhotos()
                    }
                }
            }
        }
        
        @ViewBuilder
        private func customSearchBar() -> some View {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search photos", text: $searchViewModel.searchQuery)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.system(size: 22))
                    .padding(.vertical, 10)
            }
            .padding(.horizontal)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .onChange(of: searchViewModel.searchDebounced) { _ in
                Task {
                    await searchViewModel.searchPhotos()
                }
            }
        }

    private func loadingView() -> some View {
        ProgressView()
    }

    private func successView() -> some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let spacing: CGFloat = 16
            let columnCount = screenWidth > 700 ? 3 : 2
            let totalSpacing = spacing * CGFloat(columnCount + 1)
            let itemWidth = max((screenWidth - totalSpacing) / CGFloat(columnCount), 0)

            let columns = createColumns(from: searchViewModel.photos, columnCount: columnCount)

            if itemWidth > 0 {
                ScrollView {
                    HStack(alignment: .top, spacing: spacing) {
                        ForEach(0..<columns.count, id: \.self) { columnIndex in
                            LazyVStack(spacing: spacing) {
                                ForEach(columns[columnIndex], id: \.id) { photo in
                                    NavigationLink(destination: PhotoDetailsView(photo: photo).toolbar(.hidden, for: .tabBar)) {
                                        let height = itemWidth * CGFloat.random(in: 1.2...1.8)

                                        WebImage(url: photo.imageURL) { phase in
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
                                        .frame(width: itemWidth, height: height)
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
                    }
                    .padding(.horizontal)
                    .padding(.top, spacing)
                }
            } else {
                ProgressView()
            }
        }
    }

    private func emptyView() -> some View {
        InfoView(message: "No data found")
    }

    private func errorView(errorMsg: String) -> some View {
        InfoView(message: errorMsg)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchView()
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("iPhone SE Portrait")

            SearchView()
                .previewDevice("iPhone SE (3rd generation)")
                .previewInterfaceOrientation(.landscapeLeft)
                .previewDisplayName("iPhone SE Landscape")

            SearchView()
                .previewDevice("iPad Pro (11-inch) (4th generation)")
                .previewDisplayName("iPad Pro")
        }
    }
}
