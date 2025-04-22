//
//  GetUserActivitiesUseCase.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 22/4/25.
//

import Foundation

class GetUserActivitiesUseCase {
    private let userActivityDataSource: UserActivityDataSource
    
    init(userActivityDataSource: UserActivityDataSource) {
        self.userActivityDataSource = userActivityDataSource
    }

    func execute() -> Result<[UserActivity], AppError> {
        do {
            let actions = try userActivityDataSource.fetchAllActions()
            return .success(actions)
        } catch {
            return .failure(error.toAppError())
        }
    }
}
