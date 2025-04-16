//
//  MovieDataSource.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

typealias PhotoResponse = BaseResponse<PhotoModel>

protocol PhotoDataSource {
    func getPhotos(from page: Int, by query: String) async throws -> BaseResponse<PhotoModel>
}

class PhotoDataSourceImpl: PhotoDataSource {
    let apiManager: APIManager
    
    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }
    
    func getPhotos(from page: Int, by query: String) async throws -> BaseResponse<PhotoModel> {
        let request = PhotoRequest(page: page, query: query)
        print(request)
        let response: PhotoResponse = try await apiManager.makeRequest(request: request)
        return response.self
    }
}
