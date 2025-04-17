//
//  PhotoListModel.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 17/4/25.
//

import Foundation

struct PhotoListModel: Codable {
    let id: UUID?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    init(id: UUID?, name: String?, photoIds: [String]?) {
        self.id = id
        self.name = name
    }
}
