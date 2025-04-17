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
}
