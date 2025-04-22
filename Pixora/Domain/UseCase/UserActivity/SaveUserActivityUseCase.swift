//
//  SaveUserActivityUseCase.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 22/4/25.
//

import Foundation

class SaveUserActivityUseCase {
    private let userActivityDataSource: UserActivityDataSource

    init(userActivityDataSource: UserActivityDataSource) {
        self.userActivityDataSource = userActivityDataSource
    }

    func execute(_ activity: UserActivity) -> Result<Void, AppError> {
        do {
            try userActivityDataSource.saveAction(activity)
            return .success(())
        } catch {
            return .failure(error.toAppError())
        }
    }
}
