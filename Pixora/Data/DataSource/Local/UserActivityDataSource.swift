//
//  UserActivityDataSource.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 22/4/25.
//

import Foundation
import CoreData

// MARK: - Protocol
protocol UserActivityDataSource {
    func saveActionEntity(_ actionEntity: UserActivityEntity) throws
    func fetchAllActionEntities() throws -> [UserActivityEntity]
}

// MARK: - Implementation
final class UserActivityDataSourceImpl: UserActivityDataSource {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    func saveActionEntity(_ actionEntity: UserActivityEntity) throws {
        try context.save()
        print("✅ UserActivityEntity guardada: \(actionEntity.id?.uuidString ?? "sin ID")")
    }

    func fetchAllActionEntities() throws -> [UserActivityEntity] {
        let request = UserActivityEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        return try context.fetch(request)
    }
}
