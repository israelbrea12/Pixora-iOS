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
            GeometryReader { geometry in
                let totalWidth = geometry.size.width
                let spacing: CGFloat = 4
                let leftImageWidth = (totalWidth - spacing) * 0.55
                let rightImageWidth = (totalWidth - spacing) * 0.45
                let imageHeight = leftImageWidth // square

                HStack(spacing: spacing) {
                    imageView(for: photos.indices.contains(0) ? photos[0] : nil)
                        .frame(width: leftImageWidth, height: imageHeight)
                        .cornerRadius(10)

                    VStack(spacing: spacing) {
                        imageView(for: photos.indices.contains(1) ? photos[1] : nil)
                            .frame(width: rightImageWidth, height: (imageHeight - spacing) / 2)
                            .cornerRadius(10)

                        imageView(for: photos.indices.contains(2) ? photos[2] : nil)
                            .frame(width: rightImageWidth, height: (imageHeight - spacing) / 2)
                            .cornerRadius(10)
                    }
                }
                .frame(height: imageHeight) // Ensure GeometryReader container respects total height
            }
            .aspectRatio(1.7, contentMode: .fit) // Use aspect ratio to auto-size height based on width

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
    private func imageView(for photo: Photo?) -> some View {
        if let data = photo?.imageData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .clipped()
        } else if let url = photo?.imageURL {
            WebImage(url: url)
                .resizable()
                .scaledToFill()
                .clipped()
        } else {
            Color.gray.opacity(0.3)
        }
    }
}


