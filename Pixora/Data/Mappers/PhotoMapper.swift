//
//  PhotoMapper.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

extension PhotoModel {
    func toDomain() -> Photo {
        return Photo(
            id: self.id,
            description: self.description,
            color: self.color,
            likes: self.likes,
            imageURL: self.urls?.regular,
            photographerUsername: self.user?.username,
            photographerProfileImage: self.user?.profile_image?.small,
            isFavorite: false
        )
    }
}
