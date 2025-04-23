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
            ZStack(
                content: {
                    switch myPhotosViewModel.state{
                    case .loading,
                            .initial:
                        loadingView()
                    case .success:
                        successView()
                    case .error(let error):
                        errorView(errorMsg: error)
                    case .empty:
                        emptyView()
                    }
                }
            )
            .onAppear {
                            myPhotosViewModel.fetchMyPhotos() // 🔥 recarga cada vez que se ve la pantalla
                        }
        }
    }
    func successView() -> some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(myPhotosViewModel.photos, id: \.id) { photo in
                    if let data = photo.imageData, let uiImage = UIImage(data: data) {
                        VStack(alignment: .leading) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(15)

                            if let description = photo.description {
                                Text(description)
                                    .font(.headline)
                            }

                            if let username = photo.photographerUsername {
                                Text("@\(username)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(20)
                        .shadow(radius: 4)
                    }
                }
            }
            .padding()
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
}


#Preview {
    MyPhotosView()
}
