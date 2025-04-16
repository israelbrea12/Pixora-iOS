//
//  FavsViewModel.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

@MainActor
final class FavsViewModel: ObservableObject {
    @Published var photos: [Photo] = []
    @Published var state: ViewState = .loading
    
    private let getFavoritePhotosUseCase: GetFavoritePhotosUseCase
    
    init(getFavoritePhotosUseCase: GetFavoritePhotosUseCase) {
        self.getFavoritePhotosUseCase = getFavoritePhotosUseCase
        Task {
            await fetchFavorites()
        }
    }
    
    public func fetchFavorites() async {
        state = .loading
        let result = await getFavoritePhotosUseCase.execute()
        
        switch result {
        case .success(let favorites):
            self.photos = favorites
            self.state = favorites.isEmpty ? .empty : .success
        case .failure(let error):
            self.state = .error(error.localizedDescription)
        }
    }
}

