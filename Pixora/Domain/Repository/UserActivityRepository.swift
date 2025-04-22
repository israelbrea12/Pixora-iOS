//
//  UserActivityRepository.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 22/4/25.
//

import Foundation

protocol UserActivityRepository {
    func saveAction(_ action: UserActivity) -> Result<Bool, AppError>
    func getAllActions() -> Result<[UserActivity], AppError>
}
