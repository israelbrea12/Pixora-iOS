//
//  PhotoListDetailViewModel.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 21/4/25.
//

import Foundation

@MainActor
final class PhotoListDetailViewModel: ObservableObject {
    
    // MARK: - Publisheds
    @Published var state: ViewState = .initial
    @Published var photos: [Photo] = []

    
    // MARK: - Use cases
    private let getPhotosFromListUseCase: GetPhotosFromPhotoListUseCase

    
    // MARK: - Lifecycle functions
    init(getPhotosFromListUseCase: GetPhotosFromPhotoListUseCase) {
        self.getPhotosFromListUseCase = getPhotosFromListUseCase
    }

    
    // MARK: - Functions
    func loadPhotos(list: PhotoList) async {
        state = .loading

        switch getPhotosFromListUseCase.execute(for: list) {
        case .success(let photos):
            if photos.isEmpty {
                state = .empty
            } else {
                self.photos = photos
                state = .success
            }
        case .failure(let error):
            state = .error(error.localizedDescription)
        }
    }
}
