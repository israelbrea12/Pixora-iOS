//
//  PhotoMapper.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation
import CoreData

// MARK: - Mapping

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

extension FavoritePhotoEntity {
    func toDomain() -> Photo {
        Photo(
            id: id,
            description: descriptionText,
            color: color,
            likes: Int(likes),
            imageURL: URL(string: imageURL ?? ""),
            photographerUsername: photographerUsername,
            photographerProfileImage: URL(string: photographerProfileImage ?? ""),
            isFavorite: true
        )
    }
}

extension Photo {
    func toData(context: NSManagedObjectContext) -> FavoritePhotoEntity {
        let entity = FavoritePhotoEntity(context: context)
        entity.id = self.id
        entity.descriptionText = self.description
        entity.color = self.color
        entity.likes = Int32(self.likes ?? 0)
        entity.imageURL = self.imageURL?.absoluteString
        entity.photographerUsername = self.photographerUsername
        entity.photographerProfileImage = self.photographerProfileImage?.absoluteString
        return entity
    }
}

