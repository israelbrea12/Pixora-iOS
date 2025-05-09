//
//  PhotoListDataSource.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 17/4/25.
//

import Foundation
import CoreData

// MARK: - Protocol
protocol PhotoListDataSource {
    
    func fetchListEntities() throws -> [PhotoListEntity]
    func createListEntity(_ listEntity: PhotoListEntity) throws
    func addPhotoEntity(_ photoEntity: PhotoEntity, toListEntityWithId listId: UUID) throws
    func getPhotoEntities(forListEntityWithId listId: UUID) throws -> [PhotoEntity]
}

// MARK: - Implementation
class PhotoListDataSourceImpl: PhotoListDataSource {

    private let context: NSManagedObjectContext

    init(
        context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    ) {
        self.context = context
    }

    func fetchListEntities() throws -> [PhotoListEntity] {
        let request = PhotoListEntity.fetchRequest()
        return try context.fetch(request)
    }

    func createListEntity(_ listEntity: PhotoListEntity) throws {
        try context.save()
        print("✅ PhotoListEntity creada: \(listEntity.name ?? "sin nombre")")
    }

    func addPhotoEntity(_ photoEntity: PhotoEntity, toListEntityWithId listId: UUID) throws {
        let listRequest = PhotoListEntity.fetchRequest()
        listRequest.predicate = NSPredicate(format: "id == %@", listId.uuidString)
        guard let listEntity = try context.fetch(listRequest).first else {
            throw NSError(domain: "PhotoListDataSource", code: 404, userInfo: [NSLocalizedDescriptionKey: "PhotoListEntity no encontrada con ID: \(listId.uuidString)"])
        }
        
        let entry = PhotoInListEntity(context: context)
        entry.id = UUID()
        entry.addedAt = Date()
        entry.list = listEntity
        entry.photo = photoEntity

        try context.save()
        print("✅ PhotoEntity \(photoEntity.id ?? "") añadido a PhotoListEntity: \(listEntity.name ?? "")")
    }

    func getPhotoEntities(forListEntityWithId listId: UUID) throws -> [PhotoEntity] {
        let request = PhotoListEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", listId.uuidString)

        guard let listEntity = try context.fetch(request).first,
              let photoInListSet = listEntity.photosInList as? Set<PhotoInListEntity> else {
            return []
        }

        return photoInListSet
            .sorted(by: { $0.addedAt ?? .distantPast < $1.addedAt ?? .distantPast })
            .compactMap { $0.photo }
    }
}
