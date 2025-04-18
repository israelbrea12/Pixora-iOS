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

extension PhotoEntity {
    func toDomain() -> Photo {
        Photo(
            id: id,
            description: descriptionText,
            color: color,
            likes: Int(likes),
            imageURL: URL(string: imageURL ?? ""),
            photographerUsername: photographerUsername,
            photographerProfileImage: URL(string: photographerProfileImage ?? ""),
            isFavorite: isFavorite
        )
    }
}

extension Photo {
    func toData(context: NSManagedObjectContext) -> PhotoEntity {
        let request = NSFetchRequest<PhotoEntity>(entityName: "PhotoEntity")
        request.predicate = NSPredicate(format: "id == %@", id ?? "")
        let entity = (try? context.fetch(request).first) ?? PhotoEntity(context: context)

        entity.id = self.id ?? UUID().uuidString
        entity.descriptionText = self.description ?? ""
        entity.color = self.color ?? "#FFFFFF"
        entity.likes = Int32(self.likes ?? 0)
        entity.imageURL = self.imageURL?.absoluteString ?? ""
        entity.photographerUsername = self.photographerUsername ?? "Desconocido"
        entity.photographerProfileImage = self.photographerProfileImage?.absoluteString ?? ""
        entity.isFavorite = self.isFavorite
        return entity
    }
}
