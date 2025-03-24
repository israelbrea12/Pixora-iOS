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
                        .background(Color.gray.opacity(0.3))
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8)
                case .success(let image):
                    image.resizable()
                        .scaledToFill()
                        .clipped()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(8)
                @unknown default:
                    EmptyView()
                }
            }
        }
    }
}
