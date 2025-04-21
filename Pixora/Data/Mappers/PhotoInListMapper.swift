//
//  PhotoInListMapper.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 21/4/25.
//

import Foundation
import CoreData

extension PhotoInListEntity {
    func toDomain() -> PhotoInList? {
        guard let id = id,
              let photoEntity = photo,
              let addedAt = addedAt else {
            return nil
        }

        return PhotoInList(
            id: id,
            photo: photoEntity.toDomain(),
            addedAt: addedAt
        )
    }
}

extension PhotoInList {
    func toData(context: NSManagedObjectContext, photoEntity: PhotoEntity, listEntity: PhotoListEntity) -> PhotoInListEntity {
        let entity = PhotoInListEntity(context: context)
        entity.id = id
        entity.photo = photoEntity
        entity.list = listEntity
        entity.addedAt = addedAt
        return entity
    }
}
