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
        listEntity.addToPhotos(photoEntity)

        try context.save()
    }
}
