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
    @Published var photos: [Photo] = []
    @Published var state: ViewState = .initial

    private let fetchMyPhotosUseCase: FetchMyPhotosUseCase
    private var initialLoadDone = false

    init(fetchMyPhotosUseCase: FetchMyPhotosUseCase) {
        self.fetchMyPhotosUseCase = fetchMyPhotosUseCase
    }

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

