//
//  MyPhotosView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 22/4/25.
//

import SwiftUI

struct MyPhotosView: View {
    
    @StateObject var myPhotosViewModel = Resolver.shared.resolve(MyPhotosViewModel.self)

    var body: some View {
        NavigationStack {
            ZStack{
                switch myPhotosViewModel.state{
                case .loading,
                        .initial:
                    ProgressView()
                case .success:
                    successView()
                case .error(let error):
                    errorView(errorMsg: error)
                case .empty:
                    emptyView()
                }
            }
            .onAppear {
                Task {
                    await myPhotosViewModel.fetchMyPhotos()
                }
            }
        }
        
    }
    func successView() -> some View {
        ScrollView {
            let columns = [
                GridItem(.adaptive(minimum: 150), spacing: 8)
            ]

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(myPhotosViewModel.photos, id: \.id) { photo in
                    if let data = photo.imageData, let uiImage = UIImage(
                        data: data
                    ) {
                        NavigationLink(
                            destination: PhotoDetailsView(photo: photo)
                                .toolbar(.hidden, for: .tabBar)
                        ) {
                            GeometryReader { geometry in
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(
                                        width: geometry.size.width,
                                        height: geometry.size.width
                                    )
                                    .clipped()
                                    .cornerRadius(12)
                            }
                            .aspectRatio(1, contentMode: .fit)
                        }
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 8)
        }
    }
    
    private func loadingView() -> some View {
        ProgressView()
    }
    
    private func emptyView() -> some View {
        InfoView(message: "No photos yet")
    }
    
    private func errorView(errorMsg: String) -> some View {
        InfoView(message: errorMsg)
    }
}


#Preview {
    MyPhotosView()
}
