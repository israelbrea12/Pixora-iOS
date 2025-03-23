//
//  NetworkManagerImpl.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

protocol NetworkManager {
    func makeRequest(requestData: RequestProtocol) async throws -> Data
}

final class NetworkManagerImpl: NetworkManager {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func makeRequest(requestData: RequestProtocol) async throws -> Data {
        
        let request: URLRequest = try requestData.request()
        
        print(request)
        
        do {
            let (data, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw NetworkError.invalidServerResponse
            }
            
            return data
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
}
