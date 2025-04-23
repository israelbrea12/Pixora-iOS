//
//  FavoritePhotoDataSource.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 16/4/25.
//

import Foundation
import CoreData

// MARK: - Protocol
protocol FavoritePhotoDataSource {
    func saveFavorite(_ photo: Photo) throws
    func deleteFavorite(_ photo: Photo) throws
    func fetchFavorites() throws -> [Photo]
    func isFavorite(photo: Photo) throws -> Bool
}

// MARK: - Implementación
class FavoritePhotoDataSourceImpl: FavoritePhotoDataSource {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }
    
    func saveFavorite(_ photo: Photo) throws {
        var updatedPhoto = photo
        updatedPhoto.isFavorite = true
        _ = updatedPhoto.toData(context: context)
        try context.save()
        print("✅ Foto guardada como favorita: \(photo.id ?? "sin ID")")
    }


    func deleteFavorite(_ photo: Photo) throws {
        let request = PhotoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", photo.id ?? "")
        if let result = try context.fetch(request).first {
            result.isFavorite = false
            try context.save()
        }
    }

    func fetchFavorites() throws -> [Photo] {
        let request = PhotoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == true")
        return try context.fetch(request).map { $0.toDomain() }
    }

    func isFavorite(photo: Photo) throws -> Bool {
        let request = PhotoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@ AND isFavorite == true", photo.id ?? "")
        return try context.count(for: request) > 0
    }
}

