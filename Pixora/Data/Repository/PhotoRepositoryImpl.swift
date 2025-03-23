//
//  PhotoRepositoryImpl.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

class PhotoRepositoryImpl: PhotoRepository {
    
    private let photoDataSource: PhotoDataSource
//    private let favDataSource: FavDataSource
    
    init(photoDataSource: PhotoDataSource) {
        self.photoDataSource = photoDataSource
    }
    
    func getPhotos(from page: Int) async -> Result<[Photo], AppError> {
        do {
            let photosData = try await photoDataSource.getPhotos(from: page)
            return .success(photosData.map{$0.toDomain()})
        } catch {
            return .failure(error.toAppError())
        }
    }
    
//    func saveMovieAsFavorite(_ movie: Movie) -> Result<Bool, AppError> {
//        let fav = movie.toData()
//        do{
//            try favDataSource.addFavorite(fav)
//            return .success(true)
//        }catch{
//            return .failure(error.toAppError())
//        }
//    }
//
//    func deleteMovieAsFavorite(_ movie: Movie) -> Result<Bool, AppError> {
//        let fav = movie.toData()
//
//        do{
//            try favDataSource.removeFavorite(fav)
//            return .success(true)
//        }catch{
//            return .failure(error.toAppError())
//        }
//    }
//
//    func fetchFavoriteMovies() -> Result<[Movie], AppError> {
//        do{
//           let favorites = try favDataSource.fetchFavorites()
//            return .success(favorites.map{$0.toDomain()})
//        }catch{
//            return .failure(error.toAppError())
//        }
//    }
}
