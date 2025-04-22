//
//  PhotoDetailsViewModel.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 28/3/25.
//

import Foundation

@MainActor
final class PhotoDetailsViewModel: ObservableObject {
    @Published var isFavorite: Bool = false
    @Published var state: ViewState = .loading
    @Published var likes: Int = 0
    @Published var isNewListSheetPresented = false
    @Published var isSavedInAnyList: Bool = false

    private let setPhotoAsFavoriteUseCase: SetPhotoAsFavoriteUseCase
    private let deletePhotoAsFavoriteUseCase: DeletePhotoAsFavoriteUseCase
    private let isPhotoFavoriteUseCase: IsPhotoFavoriteUseCase
    private let isPhotoInAnyListUseCase: IsPhotoInAnyListUseCase
    private let saveUserActivityUseCase: SaveUserActivityUseCase

    init(
        setPhotoAsFavoriteUseCase: SetPhotoAsFavoriteUseCase,
        deletePhotoAsFavoriteUseCase: DeletePhotoAsFavoriteUseCase,
        isPhotoFavoriteUseCase: IsPhotoFavoriteUseCase,
        isPhotoInAnyListUseCase: IsPhotoInAnyListUseCase,
        saveUserActivityUseCase: SaveUserActivityUseCase
    ) {
        self.setPhotoAsFavoriteUseCase = setPhotoAsFavoriteUseCase
        self.deletePhotoAsFavoriteUseCase = deletePhotoAsFavoriteUseCase
        self.isPhotoFavoriteUseCase = isPhotoFavoriteUseCase
        self.isPhotoInAnyListUseCase = isPhotoInAnyListUseCase
        self.saveUserActivityUseCase = saveUserActivityUseCase
    }

    func load(photo: Photo) async -> Bool {
        self.state = .loading
        self.likes = photo.likes ?? 0
        let result = await isPhotoFavoriteUseCase.execute(with: photo)
        switch result {
        case .success(let isFav):
            self.isFavorite = isFav
            self.state = .success
            return isFav
        case .failure(let error):
            self.state = .error(error.localizedDescription)
            return false
        }
    }


    func toggleFavorite(for photo: Photo) async -> Bool {
        if isFavorite {
            let result = await deletePhotoAsFavoriteUseCase.execute(with: photo)
            if case .success = result {
                self.isFavorite = false
                self.likes = max(self.likes - 1, 0)
                return false
            }
        } else {
            let result = await setPhotoAsFavoriteUseCase.execute(with: photo)
            if case .success = result {
                self.isFavorite = true
                self.likes += 1
                
                // Guardar actividad
                let activity = UserActivity(
                    id: UUID(),
                    type: .likedPhoto,
                    photo: photo,
                    listName: nil,
                    timestamp: Date()
                )
                _ = saveUserActivityUseCase.execute(activity)
                return true
            }
        }
        return isFavorite
    }
    
    func checkIfPhotoIsInAnyList(_ photo: Photo) {
        // Simula que tienes un use case como este:
        let result = isPhotoInAnyListUseCase.execute(photo)
        if case .success(let isInList) = result {
            self.isSavedInAnyList = isInList
        }
    }
}
