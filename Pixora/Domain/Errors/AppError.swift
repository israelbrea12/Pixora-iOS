//
//  AppError.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

enum AppError: Error, Equatable {
    case networkError(String)
    case authenticationError(String)
    case databaseError(String)
    case unknownError(String)
}
