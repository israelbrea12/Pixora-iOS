//
//  UserActivityDataSource.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 22/4/25.
//

import Foundation
import CoreData

protocol UserActivityDataSource {
    func saveAction(_ action: UserActivity) throws
    func fetchAllActions() throws -> [UserActivity]
}

class UserActivityDataSourceImpl: UserActivityDataSource {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    func saveAction(_ action: UserActivity) throws {
        let entity = UserActivityEntity(context: context)
        entity.id = action.id
        entity.type = action.type.rawValue
        entity.timestamp = action.timestamp
        entity.listName = action.listName
        entity.photo = action.photo.toData(context: context)
        try context.save()
    }

    func fetchAllActions() throws -> [UserActivity] {
        let request = UserActivityEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        return try context.fetch(request).compactMap { $0.toDomain() }
    }
}

