//
//  PhotoListDataSource.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 17/4/25.
//

import Foundation
import CoreData

protocol PhotoListDataSource {
    func fetchLists() throws -> [PhotoList]
    func createList(name: String) throws
    func addPhotoToList(_ photo: Photo, to list: PhotoList) throws
    func getPhotos(for list: PhotoList) throws -> [Photo]
}

class PhotoListDataSourceImpl: PhotoListDataSource {
    
    private let context: NSManagedObjectContext

    init(
        context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    ) {
        self.context = context
    }

    func fetchLists() throws -> [PhotoList] {
        let request = PhotoListEntity.fetchRequest()
        let result = try context.fetch(request)
        return result.map { $0.toDomain() }
    }

    func createList(name: String) throws {
        let list = PhotoList(id: UUID(), name: name)
        _ = list.toData(context: context)
        try context.save()
    }
    
    func addPhotoToList(_ photo: Photo, to list: PhotoList) throws {
        let listRequest = PhotoListEntity.fetchRequest()
        listRequest.predicate = NSPredicate(format: "id == %@", list.id.uuidString)
        guard let listEntity = try context.fetch(listRequest).first else {
            throw NSError(domain: "Lista no encontrada", code: 0)
        }

        let photoEntity = photo.toData(context: context)

        let entry = PhotoInListEntity(context: context)
        entry.id = UUID()
        entry.addedAt = Date()
        entry.list = listEntity
        entry.photo = photoEntity

        try context.save()
    }
    
    func getPhotos(for list: PhotoList) throws -> [Photo] {
        let request = PhotoListEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", list.id.uuidString)
        guard let listEntity = try context.fetch(request).first,
              let photoInListSet = listEntity.photosInList as? Set<PhotoInListEntity> else {
            return []
        }

        let sorted = photoInListSet
            .sorted(by: { $0.addedAt ?? .distantPast < $1.addedAt ?? .distantPast })
            .compactMap { $0.photo?.toDomain() }

        return sorted
    }
}
