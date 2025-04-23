//
//  Photo.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

struct Photo: Identifiable, Equatable {
    let id: String?
    let description: String?
    let color: String?
    var likes: Int?
    let imageURL: URL?
    let photographerUsername: String?
    let photographerProfileImage: URL?
    var isFavorite: Bool
    var imageData: Data? = nil

    init(id: String?, description: String?, color: String?, likes: Int?, imageURL: URL?, photographerUsername: String?, photographerProfileImage: URL?, isFavorite: Bool, imageData: Data?) {
        self.id = id
        self.description = description
        self.color = color
        self.likes = likes
        self.imageURL = imageURL
        self.photographerUsername = photographerUsername
        self.photographerProfileImage = photographerProfileImage
        self.isFavorite = isFavorite
        self.imageData = imageData
    }
}

