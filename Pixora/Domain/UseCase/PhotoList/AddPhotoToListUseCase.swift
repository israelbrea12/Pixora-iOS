//
//  AddPhotoToListUseCase.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 20/4/25.
//

import Foundation

final class AddPhotoToListUseCase {
    private let photoListRepository: PhotoListRepository

    init(photoListRepository: PhotoListRepository) {
        self.photoListRepository = photoListRepository
    }

    func execute(photo: Photo, list: PhotoList) -> Result<Bool, AppError> {
        return photoListRepository.addPhotoToList(photo, to: list)
    }
}
