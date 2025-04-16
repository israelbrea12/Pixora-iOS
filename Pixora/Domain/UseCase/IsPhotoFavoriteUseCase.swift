//
//  IsPhotoFavoriteUseCase.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 16/4/25.
//

import Foundation

final class IsPhotoFavoriteUseCase: UseCaseProtocol {
    private let photoRepository: PhotoRepository

    init(photoRepository: PhotoRepository) {
        self.photoRepository = photoRepository
    }

    func execute(with photo: Photo) async -> Result<Bool, AppError> {
        photoRepository.isPhotoFavorite(photo)
    }
}
