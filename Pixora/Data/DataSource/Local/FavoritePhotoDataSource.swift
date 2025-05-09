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
    
    func saveFavoriteEntity(_ photoEntity: PhotoEntity) throws
    func deleteFavoriteEntityBy(photoId: String) throws
    func fetchFavoriteEntities() throws -> [PhotoEntity]
    func isFavorite(photoId: String) throws -> Bool
}

// MARK: - Implementation
class FavoritePhotoDataSourceImpl: FavoritePhotoDataSource {
    
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    func saveFavoriteEntity(_ photoEntity: PhotoEntity) throws {
        try context.save()
        print("✅ PhotoEntity guardado como favorito: \(photoEntity.id ?? "sin ID")")
    }

    func deleteFavoriteEntityBy(photoId: String) throws {
        let request = PhotoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", photoId)
        if let result = try context.fetch(request).first {
            result.isFavorite = false
            try context.save()
            print("🗑️ PhotoEntity desmarcado como favorito: \(photoId)")
        } else {
            print("⚠️ PhotoEntity no encontrado para eliminar de favoritos con ID: \(photoId)")
        }
    }

    func fetchFavoriteEntities() throws -> [PhotoEntity] {
        let request = PhotoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == true")
        return try context.fetch(request)
    }

    func isFavorite(photoId: String) throws -> Bool {
        let request = PhotoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@ AND isFavorite == true", photoId)
        let count = try context.count(for: request)
        return count > 0
    }
}
