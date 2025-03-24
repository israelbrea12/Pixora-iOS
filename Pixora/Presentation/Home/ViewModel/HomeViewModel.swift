//
//  HomeViewModel.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel : ObservableObject {
    
    @Published var searchQuery = ""
    @Published var searchDebounced = ""
    @Published var photos: [Photo] = [Photo]()
    @Published var state: ViewState = .success
    
    private var page: Int = 1
    
    let getPhotosUseCase: GetPhotosUseCase
    
    
    init(getPhotosUseCase: GetPhotosUseCase){
        self.getPhotosUseCase = getPhotosUseCase
        
        $searchQuery.debounce(for: 0.5, scheduler: RunLoop.main).removeDuplicates().assign(to: &$searchDebounced)
        
        Task{
            await self.fetchPhotos()
        }
    }
    
    public func searchPhotos() async {
        photos = []
        await fetchPhotos()
    }
    
    public func fetchPhotos() async {
        state = .loading
        let queryToUse = searchDebounced.isEmpty ? "popular" : searchDebounced // Cambia "nature" por una categoría genérica
        let result = await getPhotosUseCase.execute(with: GetPhotosParam(page: page, query: queryToUse))

        switch result {
            case .success(let data):
                photos = data
                state = photos.isEmpty ? .empty : .success
            case .failure(let err):
                state = .error(err.localizedDescription)
        }
    }

}
