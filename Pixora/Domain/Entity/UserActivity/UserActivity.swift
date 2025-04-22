//
//  UserAction.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 22/4/25.
//

import Foundation

struct UserActivity {
    let id: UUID
    let type: ActionType
    let photo: Photo
    let listName: String?
    let timestamp: Date
}

enum ActionType: String {
    case likedPhoto
    case addedToList
}
