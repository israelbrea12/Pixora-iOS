//
//  MyPhotosView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 22/4/25.
//

import SwiftUI

struct MyPhotosView: View {
    @StateObject private var viewModel = MyPhotosViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.photos, id: \.id) { photo in
                        if let data = photo.imageData, let uiImage = UIImage(data: data) {
                            VStack(alignment: .leading) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(15)

                                if let description = photo.descriptionText {
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
    }
}

#Preview {
    MyPhotosView()
}
