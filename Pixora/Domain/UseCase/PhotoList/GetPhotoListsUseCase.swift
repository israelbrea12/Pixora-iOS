//
//  FetchPhotoListUseCase.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 17/4/25.
//

import Foundation

final class GetPhotoListsUseCase {
    private let photoListRepository: PhotoListRepository
    
    init(photoListRepository: PhotoListRepository) {
        self.photoListRepository = photoListRepository
    }
    
    func execute() -> Result<[PhotoList], AppError> {
        photoListRepository.getLists()
    }
}
