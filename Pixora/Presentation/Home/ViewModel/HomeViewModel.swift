//
//  HomeViewModel.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var photos: [Photo] = []
    @Published var state: ViewState = .success
    @Published var selectedCategory: String = "popular" // Categoría por defecto
    @Published var selectedIndex: Int = 0 // Nuevo estado para sincronizar con TabView
        
        private var page: Int = 1
        let getPhotosUseCase: GetPhotosUseCase
        
        let categories = [
            "popular",
            "nature",
            "people",
            "animals",
            "technology",
            "travel"
        ]
    
    
    init(getPhotosUseCase: GetPhotosUseCase){
        self.getPhotosUseCase = getPhotosUseCase
        
        // Sincronizar índice inicial con la categoría seleccionada
                if let initialIndex = categories.firstIndex(of: selectedCategory) {
                    selectedIndex = initialIndex
                }
        
        Task {
            await self.fetchPhotos()
        }
    }

    public func fetchPhotos() async {
        state = .loading
        let result = await getPhotosUseCase.execute(with: GetPhotosParam(page: page, query: selectedCategory))

        switch result {
            case .success(let data):
                photos = data
                state = photos.isEmpty ? .empty : .success
            case .failure(let err):
                state = .error(err.localizedDescription)
        }
    }
    
    public func updateCategory(_ category: String) {
        if let index = categories.firstIndex(of: category) {
            selectedIndex = index
        }
        selectedCategory = category
        Task {
            await fetchPhotos()
        }
    }

}
