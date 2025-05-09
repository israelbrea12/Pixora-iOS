//
//  MyPhotosDataSource.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/4/25.
//

import Foundation
import CoreData

// MARK: - Protocol
protocol MyPhotosDataSource {
    func fetchMyPhotos() throws -> [PhotoEntity]
    func saveMyPhoto(_ photo: Photo) throws
}

// MARK: - Implementation
class MyPhotosDataSourceImpl: MyPhotosDataSource {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    func fetchMyPhotos() throws -> [PhotoEntity] {
        let request: NSFetchRequest<PhotoEntity> = PhotoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "imageData != nil")
        return try context.fetch(request)
    }

    func saveMyPhoto(_ photo: Photo) throws {
        
        let entity = PhotoEntity(context: context)
        entity.id = photo.id
        entity.descriptionText = photo.description
        entity.color = photo.color
        entity.photographerUsername = photo.photographerUsername
        entity.isFavorite = photo.isFavorite
        entity.imageData = photo.imageData
        
        try context.save()
    }
}
