//
//  PhotoRow.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct PhotoRow: View {
    
    let photo: Photo
    let removeAction: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 12) {
            WebImage(
                url: photo.imageURL,
                transaction: Transaction(animation: .easeInOut)
            ) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 80, height: 120)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(8)
                case .success(let image):
                    image.resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 120)
                        .clipped()
                        .cornerRadius(8)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 120)
                        .foregroundColor(.gray)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(8)
                @unknown default:
                    EmptyView()
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(photo.photographerUsername ?? "Sin título")
                        .font(.headline)
                        .lineLimit(1)

                    Spacer()
                    
                    if let removeAction = removeAction {
                        Button(action: removeAction) {
                            Image(systemName: photo.isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(.red)
                                .font(.system(size: 20))
                        }
                    }
                }

                if let description = photo.description, !description.isEmpty {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(3)
                } else {
                    Spacer()
                }
            }
            .padding()
        }
        .padding(.horizontal, 8)
    }
}
