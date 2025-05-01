//
//  MyPhotosViewModel.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/4/25.
//

import Foundation
import SwiftUI
import CoreData

@MainActor
final class MyPhotosViewModel: ObservableObject {
    
    // MARK: - Publisheds
    @Published var photos: [Photo] = []
    @Published var state: ViewState = .initial

    
    // MARK: - Private vars
    private var initialLoadDone = false
    
    
    // MARK: - Use cases
    private let fetchMyPhotosUseCase: FetchMyPhotosUseCase
    

    // MARK: - Lifecycle functions
    init(fetchMyPhotosUseCase: FetchMyPhotosUseCase) {
        self.fetchMyPhotosUseCase = fetchMyPhotosUseCase
    }

    
    // MARK: - Functions
    func loadIfNeeded() async {
        guard !initialLoadDone else { return }
        initialLoadDone = true
        await fetchMyPhotos()
    }

    public func fetchMyPhotos() async {
        state = .loading
        let result = await fetchMyPhotosUseCase.execute()
        switch result {
        case .success(let myPhotos):
            self.photos = myPhotos
            self.state = myPhotos.isEmpty ? .empty : .success
        case .failure(let error):
            self.state = .error(error.localizedDescription)
        }
    }
}

