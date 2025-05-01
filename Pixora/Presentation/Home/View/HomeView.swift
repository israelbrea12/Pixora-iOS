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
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    categorySelectionView()
                    categoryView(for: homeViewModel.selectedCategory)
                }
            }
        }
    }
    
    private func categoryView(for category: String) -> some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let columnCount = screenWidth > 700 ? 3 : 2
            let spacing: CGFloat = 16
            let itemWidth = (screenWidth - (spacing * CGFloat(columnCount + 1))) / CGFloat(
                columnCount
            )
            let columns = createColumns(
                from: homeViewModel.photos,
                columnCount: columnCount
            )

            if itemWidth > 0 {
                ScrollView {
                    VStack {
                        ZStack {
                            switch homeViewModel.state {
                            case .loading:
                                loadingView()
                            case .success:
                                HStack(alignment: .top, spacing: spacing) {
                                    ForEach(
                                        0..<columns.count,
                                        id: \.self
                                    ) { columnIndex in
                                        LazyVStack(spacing: spacing) {
                                            ForEach(
                                                columns[columnIndex],
                                                id: \.id
                                            ) { photo in
                                                NavigationLink(
                                                    destination: PhotoDetailsView(
                                                        photo: photo
                                                    )
                                                    .toolbar(
                                                        .hidden,
                                                        for: .tabBar
                                                    )
                                                ) {
                                                    let height = screenWidth > 700 ? CGFloat.random(in: 300...500) : CGFloat.random(
                                                        in: 150...300
                                                    )
                                                    WebImage(
                                                        url: photo.imageURL
                                                    ) { phase in
                                                        switch phase {
                                                        case .empty:
                                                            ZStack {
                                                                Rectangle()
                                                                    .fill(
                                                                        Color.gray
                                                                            .opacity(
                                                                                0.1
                                                                            )
                                                                    )
                                                                ProgressView()
                                                            }
                                                        case .success(
                                                            let image
                                                        ):
                                                            image
                                                                .resizable()
                                                                .scaledToFill()
                                                        case .failure:
                                                            ZStack {
                                                                Rectangle()
                                                                    .fill(
                                                                        Color.red
                                                                            .opacity(
                                                                                0.1
                                                                            )
                                                                    )
                                                                Image(
                                                                    systemName: "xmark.octagon"
                                                                )
                                                                .foregroundColor(
                                                                    .red
                                                                )
                                                            }
                                                        @unknown default:
                                                            EmptyView()
                                                        }
                                                    }
                                                    .frame(
                                                        width: itemWidth,
                                                        height: height
                                                    )
                                                    .clipped()
                                                    .cornerRadius(8)
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.top, spacing)
                            case .error(let errorMessage):
                                errorView(errorMsg: errorMessage)
                            default:
                                emptyView()
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .onAppear {
                    if homeViewModel.selectedCategory != category || homeViewModel.photos.isEmpty {
                        homeViewModel.updateCategory(category)
                    }
                }
            }
            else {
                ProgressView()
            }

        }
    }
    
    private func loadingView() -> some View {
        ProgressView()
    }
    
    private func emptyView() -> some View {
        InfoView(message: "No data found")
    }
    
    private func errorView(errorMsg: String) -> some View {
        InfoView(message: errorMsg)
    }
    
    private func categorySelectionView() -> some View {
        let screenWidth = UIScreen.main.bounds.width
        let isWide = screenWidth > 700
        let horizontalPadding: CGFloat = isWide ? 30 : 20
        let verticalPadding: CGFloat = isWide ? 14 : 10
        let fontSize: CGFloat = isWide ? 18 : 14

        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: isWide ? 16 : 12) {
                ForEach(homeViewModel.categories, id: \.self) { category in
                    Button(action: {
                        homeViewModel.updateCategory(category)
                    }) {
                        Text(category.capitalized)
                            .font(.system(size: fontSize, weight: .medium))
                            .padding(.vertical, verticalPadding)
                            .padding(.horizontal, horizontalPadding)
                            .background {
                                if homeViewModel.selectedCategory == category {
                                    LinearGradient.mainBluePurple
                                } else {
                                    Color(.systemGray5)
                                }
                            }

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
        Group {
            HomeView()
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("iPhone SE Portrait")

            HomeView()
                .previewDevice("iPhone SE (3rd generation)")
                .previewInterfaceOrientation(.landscapeLeft)
                .previewDisplayName("iPhone SE Landscape")

            HomeView()
                .previewDevice("iPad Pro (11-inch) (4th generation)")
                .previewDisplayName("iPad Pro")
        }
    }
}

