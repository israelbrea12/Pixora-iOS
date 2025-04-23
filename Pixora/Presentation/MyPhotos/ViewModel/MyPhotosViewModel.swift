//
//  MyPhotosViewModel.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/4/25.
//

import Foundation
import SwiftUI
import CoreData

class MyPhotosViewModel: ObservableObject {
    @Published var photos: [Photo] = []
    @Published var state: ViewState = .initial

    private let fetchMyPhotosUseCase: FetchMyPhotosUseCase
    
    init(fetchMyPhotosUseCase: FetchMyPhotosUseCase) {
        self.fetchMyPhotosUseCase = fetchMyPhotosUseCase
    }
    
    public func fetchMyPhotos() {
        state = .loading
        let result = fetchMyPhotosUseCase.execute()
        switch result {
        case .success(let myPhotos):
            self.photos = myPhotos
            self.state = myPhotos.isEmpty ? .empty : .success
        case .failure(let error):
            self.state = .error(error.localizedDescription)
        }
    }
}
