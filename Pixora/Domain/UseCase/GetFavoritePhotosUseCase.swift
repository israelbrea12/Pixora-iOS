//
//  GetFavoritePhotosUseCase.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 16/4/25.
//

import Foundation

final class GetFavoritePhotosUseCase {
    private let photoRepository: PhotoRepository
    
    init(photoRepository: PhotoRepository) {
        self.photoRepository = photoRepository
    }
    
    func execute() async -> Result<[Photo], AppError> {
        photoRepository.fetchFavoritePhotos()
    }
}
