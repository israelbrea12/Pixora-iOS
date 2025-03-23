//
//  DataParser.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

protocol DataParser {
    func parse<T: Decodable>(data: Data) throws -> T
}
