//
//  UserActivityMapper.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 22/4/25.
//

import Foundation

extension UserActivityEntity {
    func toDomain() -> UserActivity? {
        guard let id = id,
              let typeRaw = type,
              let type = ActionType(rawValue: typeRaw),
              let timestamp = timestamp,
              let photo = photo?.toDomain()
        else { return nil }

        return UserActivity(
            id: id,
            type: type,
            photo: photo,
            listName: listName,
            timestamp: timestamp
        )
    }
}
