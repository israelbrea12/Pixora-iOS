//
//  BaseResponse.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

struct BaseResponse<T>: Codable  where T: Codable{
    let total, total_pages: Int?
    let results: [T]?
}
