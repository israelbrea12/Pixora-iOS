//
//  FavsViewModel.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

@MainActor
final class FavsViewModel: ObservableObject {
    
    // MARK: - Publisheds
    @Published var photos: [Photo] = []
    @Published var state: ViewState = .loading
    
    
    // MARK: - Private vars
    private var initialLoadDone = false
    
    
    // MARK: - Use cases
    private let getFavoritePhotosUseCase: GetFavoritePhotosUseCase
    
    
    // MARK: - Lifecycle functions
    init(getFavoritePhotosUseCase: GetFavoritePhotosUseCase) {
        self.getFavoritePhotosUseCase = getFavoritePhotosUseCase
        Task {
            await fetchFavorites()
            initialLoadDone = true
        }
    }
    
    // MARK: - Functions
    public func refreshIfNeeded() async {
        guard initialLoadDone else { return }

        let result = await getFavoritePhotosUseCase.execute()
        switch result {
        case .success(let latestFavorites):
            if latestFavorites.map(\.id) != self.photos.map(\.id) {
                self.photos = latestFavorites
                self.state = latestFavorites.isEmpty ? .empty : .success
            }
        case .failure(let error):
            self.state = .error(error.localizedDescription)
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

