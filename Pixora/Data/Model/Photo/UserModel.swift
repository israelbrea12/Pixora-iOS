//
//  UserModel.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

struct UserModel: Codable {
    let username: String?
    let profile_image: PhotoProfileImageModel?
    
    enum CodingKeys: String, CodingKey {
        case username
        case profile_image
    }
    
    init(username: String?, profile_image: PhotoProfileImageModel?) {
        self.username = username
        self.profile_image = profile_image
    }
}
