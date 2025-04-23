//
//  FetchMyPhotosUseCase.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/4/25.
//

import Foundation

final class FetchMyPhotosUseCase {
    private let photoRepository: PhotoRepository
    
    init(photoRepository: PhotoRepository) {
        self.photoRepository = photoRepository
    }
    
    func execute() -> Result<[Photo], AppError> {
        photoRepository.fetchMyPhotos()
    }
}
