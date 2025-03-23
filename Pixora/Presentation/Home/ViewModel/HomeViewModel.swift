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
    
    @Published var photos: [Photo] = [Photo]()
    @Published var state: ViewState = .success
    
    private var page: Int = 1
    
    let getPhotosUseCase: GetPhotosUseCase
    
    
    init(getPhotosUseCase: GetPhotosUseCase){
        self.getPhotosUseCase = getPhotosUseCase
        
        Task{
            await self.fetchPhotos()
        }
    }
    
    public func fetchPhotos() async {
        state = .loading
        let result = await getPhotosUseCase.execute(with: GetPhotosParam(page: page))
        
        switch result {
            case .success(let data):
            photos.append(contentsOf: data)
            state = photos.isEmpty ? .empty : .success
            case .failure(let err):
                state = .error(err.localizedDescription)
        }

    }
}
