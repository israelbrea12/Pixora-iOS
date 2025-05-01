//
//  SearchViewModel.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

@MainActor
final class SearchViewModel: ObservableObject {

    // MARK: - Publisheds
    @Published var searchQuery = ""
    @Published var searchDebounced = ""
    @Published var photos: [Photo] = [Photo]()
    @Published var state: ViewState = .success

    
    // MARK: - Private vars
    private var page: Int = 1

    
    // MARK: - Use Cases
    let getPhotosUseCase: GetPhotosUseCase


    // MARK: - Lifecycle functions
    init(getPhotosUseCase: GetPhotosUseCase){
        self.getPhotosUseCase = getPhotosUseCase
    
        $searchQuery
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .assign(to: &$searchDebounced)
    
        Task{
            await self.fetchPhotos()
        }
    }

    
    // MARK: - Functions
    public func searchPhotos() async {
        page = 1
        photos = []
        await fetchPhotos()
    }

    public func fetchPhotos() async {
        let queryToUse = searchDebounced.isEmpty ? "popular" : searchDebounced
        let result = await getPhotosUseCase.execute(
            with: GetPhotosParam(page: page, query: queryToUse)
        )
        switch result {
        case .success(let data):
            if page == 1 {
                photos = data
            } else {
                photos.append(contentsOf: data)
            }
            state = photos.isEmpty ? .empty : .success
            page += 1
        case .failure(let err):
            state = .error(err.localizedDescription)
        }
    }
}

