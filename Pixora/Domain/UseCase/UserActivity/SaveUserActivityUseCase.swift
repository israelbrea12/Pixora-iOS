//
//  SaveUserActivityUseCase.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 22/4/25.
//

import Foundation

final class SaveUserActivityUseCase {
    private let userActivityRepository: UserActivityRepository

    init(userActivityRepository: UserActivityRepository) {
        self.userActivityRepository = userActivityRepository
    }

    func execute(_ activity: UserActivity) -> Result<Void, AppError> {
        switch userActivityRepository.saveAction(activity) {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }
}





