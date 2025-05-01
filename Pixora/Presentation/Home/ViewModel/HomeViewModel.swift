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
    
    // MARK: - Publisheds
    @Published var photos: [Photo] = []
    @Published var state: ViewState = .success
    @Published var selectedCategory: String = "popular"
    @Published var selectedIndex: Int = 0
   
    
    // MARK: - Private vars
    private var page: Int = 1
    
    
    // MARK: - Constants
    let categories = [
        "popular",
        "nature",
        "people",
        "animals",
        "technology",
        "travel"
    ]
    
    
    // MARK: - Use Cases
    let getPhotosUseCase: GetPhotosUseCase
    
    
    // MARK: - Lifecycle functions
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
    
    
    // MARK: - Functions
    public func fetchPhotos() async {
        state = .loading
        let result = await getPhotosUseCase.execute(
            with: GetPhotosParam(page: page, query: selectedCategory)
        )

        switch result {
        case .success(let data):
            photos = data
            state = photos.isEmpty ? .empty : .success
        case .failure(let err):
            state = .error(err.localizedDescription)
        }
    }
    
    public func updateCategory(_ category: String) {
        if let newIndex = categories.firstIndex(of: category) {
            selectedIndex = newIndex
        }
        selectedCategory = category
        Task {
            await fetchPhotos()
        }
    }
}
