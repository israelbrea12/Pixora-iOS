//
//  PhotoListCardView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 21/4/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct PhotoListCardView: View {
    let photoList: PhotoList
    let photos: [Photo]

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 4) {
                // Primera imagen o placeholder
                imageView(for: photos.indices.contains(0) ? photos[0].imageURL : nil)
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)

                VStack(spacing: 4) {
                    // Segunda imagen o placeholder
                    imageView(for: photos.indices.contains(1) ? photos[1].imageURL : nil)
                        .frame(width: 70, height: 48)
                        .cornerRadius(10)

                    // Tercera imagen o placeholder
                    imageView(for: photos.indices.contains(2) ? photos[2].imageURL : nil)
                        .frame(width: 70, height: 48)
                        .cornerRadius(10)
                }
            }

            Text(photoList.name)
                .font(.headline)
                .padding(.top, 4)

            Text("\(photos.count) fotos")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(8)
        .cornerRadius(16)
    }

    @ViewBuilder
    private func imageView(for url: URL?) -> some View {
        if let url = url {
            WebImage(url: url)
                .resizable()
                .scaledToFill()
                .clipped()
        } else {
            Color.gray.opacity(0.3)
        }
    }
}


