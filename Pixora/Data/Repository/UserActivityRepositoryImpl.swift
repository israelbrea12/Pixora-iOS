//
//  UserActivityRepositoryImpl.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 22/4/25.
//

import Foundation
import CoreData

final class UserActivityRepositoryImpl: UserActivityRepository {

    private let dataSource: UserActivityDataSource
    private let context: NSManagedObjectContext

    init(
        dataSource: UserActivityDataSource,
        context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    ) {
        self.dataSource = dataSource
        self.context = context
    }

    func saveAction(_ action: UserActivity) -> Result<Bool, AppError> {
        do {
            let actionEntity = UserActivityEntity(context: self.context)
            actionEntity.id = action.id
            actionEntity.type = action.type.rawValue
            actionEntity.timestamp = action.timestamp
            actionEntity.listName = action.listName

            let photoEntityForAction = action.photo.toData(context: self.context)
            actionEntity.photo = photoEntityForAction
            
            try dataSource.saveActionEntity(actionEntity)
            return .success(true)
        } catch {
            return .failure(error.toAppError())
        }
    }

    func getAllActions() -> Result<[UserActivity], AppError> {
        do {
            let actionEntities = try dataSource.fetchAllActionEntities()
            let actions = actionEntities.compactMap { $0.toDomain() }
            return .success(actions)
        } catch {
            return .failure(error.toAppError())
        }
    }
}
