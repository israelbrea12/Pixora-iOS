//
//  GetUserActivitiesUseCase.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 22/4/25.
//

import Foundation

final class GetUserActivitiesUseCase {
    private let userActivityRepository: UserActivityRepository

    init(userActivityRepository: UserActivityRepository) {
        self.userActivityRepository = userActivityRepository
    }

    func execute() -> Result<[UserActivity], AppError> {
        userActivityRepository.getAllActions()
    }
}

