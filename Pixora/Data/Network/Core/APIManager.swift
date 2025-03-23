//
//  APIManager.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

protocol APIManager {
    var networkManager: NetworkManager { get }
    var dataParser: DataParser { get }
    
    func makeRequest<T: Codable>(request: RequestProtocol) async throws -> T
}

class APIManagerImpl: APIManager {
    
    internal let networkManager: NetworkManager
    internal let dataParser: DataParser
    
    init(networkManager: NetworkManager = NetworkManagerImpl(), dataParser: DataParser = JsonDataParser()) {
        self.networkManager = networkManager
        self.dataParser = dataParser
    }
    
    func makeRequest<T: Codable>(request: RequestProtocol) async throws -> T {
        let data = try await networkManager.makeRequest(requestData: request)
        let decoded: T = try dataParser.parse(data: data)
        return decoded
    }
}
