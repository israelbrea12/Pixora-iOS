//
//  GetPhotosUseCase.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

class GetPhotosUseCase: UseCaseProtocol {
    private let photoRepository: PhotoRepository
    
    init(photoRepository: PhotoRepository) {
        self.photoRepository = photoRepository
    }
    
    func execute(with params: GetPhotosParam) async -> Result<[Photo], AppError> {
        await photoRepository.getPhotos(from: params.page, by: params.query)
    }
}
