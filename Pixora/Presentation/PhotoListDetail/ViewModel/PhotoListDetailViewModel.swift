//
//  PhotoListDetailViewModel.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 21/4/25.
//

import Foundation

@MainActor
final class PhotoListDetailViewModel: ObservableObject {
    @Published var state: ViewState = .initial
    @Published var photos: [Photo] = []

    private let getPhotosFromListUseCase: GetPhotosFromPhotoListUseCase
    
    let list: PhotoList

    init(list: PhotoList, getPhotosFromListUseCase: GetPhotosFromPhotoListUseCase) {
        self.list = list
        self.getPhotosFromListUseCase = getPhotosFromListUseCase
    }

    func loadPhotos() async {
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
