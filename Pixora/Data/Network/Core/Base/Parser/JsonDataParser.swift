//
//  JsonDataParser.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

final class JsonDataParser : DataParser {
    
    private let jsonDecoder: JSONDecoder
    
    init(decoder: JSONDecoder = JSONDecoder()) {
        self.jsonDecoder = decoder
    }
    
    func parse<T: Decodable>(data: Data) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }
    
    
}
