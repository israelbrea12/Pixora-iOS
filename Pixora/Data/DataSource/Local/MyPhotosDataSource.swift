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
    func fetchMyPhotos() throws -> [Photo]
    func saveMyPhoto(_ photo: Photo) throws

}

// MARK: - Implementación
class MyPhotosDataSourceImpl: MyPhotosDataSource {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }
    
    func fetchMyPhotos() throws -> [Photo] {
        let request: NSFetchRequest<PhotoEntity> = PhotoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "imageData != nil")
        return try context.fetch(request).map { $0.toDomain() }
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

