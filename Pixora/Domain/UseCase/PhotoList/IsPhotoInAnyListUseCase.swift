//
//  CheckPhotoInAnyListUseCase.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 21/4/25.
//

import Foundation

final class IsPhotoInAnyListUseCase {
    private let photoListRepository: PhotoListRepository

    init(photoListRepository: PhotoListRepository) {
        self.photoListRepository = photoListRepository
    }

    func execute(_ photo: Photo) -> Result<Bool, AppError> {
        return photoListRepository.isPhotoInAnyList(photo)
    }
}
