//
//  PhotoURLsModel.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

struct PhotoURLsModel: Codable {
    let regular: URL?
    
    enum CodingKeys: String, CodingKey {
        case regular
    }
    
    init(regular: URL?) {
        self.regular = regular
    }
}
