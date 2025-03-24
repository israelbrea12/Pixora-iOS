//
//  PhotoRepository.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

protocol PhotoRepository {
    func getPhotos(from page: Int, by query: String) async -> Result<[Photo], AppError>
//    func savePhotoAsFavorite(_ data: Photo)  -> Result<Bool,AppError>
//    func deletePhotoAsFavorite(_ data: Photo) -> Result<Bool,AppError>
//    func fetchFavoritePhotos() -> Result<[Photo], AppError>
}
