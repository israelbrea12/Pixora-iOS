//
//  PhotoInList.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 21/4/25.
//

import Foundation

struct PhotoInList: Identifiable, Equatable {
    let id: UUID
    let photo: Photo
    let addedAt: Date
}
