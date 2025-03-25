//
//  SearchViewModel.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

@MainActor
final class SearchViewModel: ObservableObject {

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
        page = 1  // Reiniciar la paginación
        photos = []
        await fetchPhotos()
    }


    public func fetchPhotos() async {
        let queryToUse = searchDebounced.isEmpty ? "popular" : searchDebounced
        let result = await getPhotosUseCase.execute(with: GetPhotosParam(page: page, query: queryToUse))

        switch result {
            case .success(let data):
                if page == 1 {
                    photos = data
                } else {
                    photos.append(contentsOf: data)
                }
                state = photos.isEmpty ? .empty : .success
                page += 1  // Incrementamos la página solo si hay datos
            case .failure(let err):
                state = .error(err.localizedDescription)
        }
    }


}

