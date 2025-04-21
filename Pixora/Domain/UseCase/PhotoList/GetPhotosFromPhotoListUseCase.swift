//
//  GetPhotosFromPhotoListUseCase.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 21/4/25.
//

import Foundation

final class GetPhotosFromPhotoListUseCase {
    private let photoListRepository: PhotoListRepository

    init(photoListRepository: PhotoListRepository) {
        self.photoListRepository = photoListRepository
    }

    func execute(for list: PhotoList) -> Result<[Photo], AppError> {
        return photoListRepository.getPhotosFromPhotoList(for: list)
    }
}
