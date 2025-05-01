//
//  UserActivityRepositoryImpl.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 22/4/25.
//

import Foundation

final class UserActivityRepositoryImpl: UserActivityRepository {
    
    private let dataSource: UserActivityDataSource

    init(dataSource: UserActivityDataSource) {
        self.dataSource = dataSource
    }

    func saveAction(_ action: UserActivity) -> Result<Bool, AppError> {
        do {
            try dataSource.saveAction(action)
            return .success(true)
        } catch {
            return .failure(error.toAppError())
        }
    }

    func getAllActions() -> Result<[UserActivity], AppError> {
        do {
            let actions = try dataSource.fetchAllActions()
            return .success(actions)
        } catch {
            return .failure(error.toAppError())
        }
    }
}
