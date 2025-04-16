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

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Favorites")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                    .padding(.top)
                
                content()
            }
        }
    }
    
    @ViewBuilder
    private func content() -> some View {
        switch favsViewModel.state {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .success:
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(favsViewModel.photos, id: \.id) { photo in
                        NavigationLink(destination: PhotoDetailsView(photo: photo).toolbar(.hidden, for: .tabBar)) {
                            WebImage(url: photo.imageURL)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 130)
                                .clipped()
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top)
            }
        case .empty:
            InfoView(message: "No favorites yet")
        case .error(let message):
            InfoView(message: message)
        default:
            EmptyView()
        }
    }
}

#Preview {
    FavsView()
}

