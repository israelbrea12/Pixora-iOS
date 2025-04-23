//
//  SaveMyPhotoUseCase.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/4/25.
//

import Foundation

import Foundation

final class SaveMyPhotoUseCase {
    private let photoRepository: PhotoRepository

    init(photoRepository: PhotoRepository) {
        self.photoRepository = photoRepository
    }

    func execute(photo: Photo) -> Result<Bool, AppError> {
        photoRepository.saveMyPhoto(photo)
    }
}
