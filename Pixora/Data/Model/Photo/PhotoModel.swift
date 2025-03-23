//
//  PhotoModel.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

struct PhotoModel: Codable {
    let id: String?
    let description: String?
    let color: String?
    let likes: Int?
    let urls: PhotoURLsModel?
    let user: UserModel?
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case color
        case likes
        case urls
        case user
    }
    
    init(id: String?, description: String?, color: String?, likes: Int?, urls: PhotoURLsModel?, user: UserModel?) {
        self.id = id
        self.description = description
        self.color = color
        self.likes = likes
        self.urls = urls
        self.user = user
    }
}
