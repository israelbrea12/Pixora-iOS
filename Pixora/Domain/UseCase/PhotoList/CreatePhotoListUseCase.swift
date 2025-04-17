//
//  CreatePhotoListUseCase.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 17/4/25.
//

import Foundation

final class CreatePhotoListUseCase: UseCaseProtocol {
    private let photoListRepository: PhotoListRepository
    
    init(photoListRepository: PhotoListRepository) {
        self.photoListRepository = photoListRepository
    }
    
    func execute(with name: String) -> Result<Bool, AppError> {
        photoListRepository.addList(name: name)
    }
}
