//
//  PhotoListMapper.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 17/4/25.
//

import Foundation
import CoreData

extension PhotoListEntity {
    func toDomain() -> PhotoList {
        PhotoList(
            id: id ?? UUID(),
            name: name ?? ""
        )
    }
}

extension PhotoList {
    func toData(context: NSManagedObjectContext) -> PhotoListEntity {
        let entity = PhotoListEntity(context: context)
        entity.id = self.id
        entity.name = self.name
        return entity
    }
}


