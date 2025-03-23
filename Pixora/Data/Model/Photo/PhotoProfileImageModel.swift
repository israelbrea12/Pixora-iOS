//
//  PhotoProfileImageModel.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

struct PhotoProfileImageModel: Codable {
    let small: URL?
    
    
    enum CodingKeys: String, CodingKey {
        case small
    }
    
    init(small: URL?) {
        self.small = small
    }
}
