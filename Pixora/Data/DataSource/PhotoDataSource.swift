//
//  MovieDataSource.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

typealias PhotoResponse = [PhotoModel]

protocol PhotoDataSource {
    func getPhotos(from page: Int) async throws -> [PhotoModel]
}

class PhotoDataSourceImpl: PhotoDataSource {
    let apiManager: APIManager
    
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }
    
    func getPhotos(from page: Int) async throws -> [PhotoModel] {
        let request = PhotoRequest(page: page)
        print(request)
        let response: PhotoResponse = try await apiManager.makeRequest(request: request)
        return response.self
    }
}
