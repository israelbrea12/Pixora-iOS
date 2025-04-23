//
//  PhotoRepositoryImpl.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

class PhotoRepositoryImpl: PhotoRepository {
    
    private let photoDataSource: PhotoDataSource
    private let favDataSource: FavoritePhotoDataSource
    private let myPhotosDataSource: MyPhotosDataSource
    
    init(photoDataSource: PhotoDataSource, favDataSource: FavoritePhotoDataSource,
    myPhotosDataSource: MyPhotosDataSource) {
        self.photoDataSource = photoDataSource
        self.favDataSource = favDataSource
        self.myPhotosDataSource = myPhotosDataSource
    }
    
    func getPhotos(from page: Int, by query: String) async -> Result<[Photo], AppError> {
        do {
            let photosData = try await photoDataSource.getPhotos(from: page, by: query)
            return .success(photosData.results?.map{$0.toDomain()} ?? [])
        } catch {
            return .failure(error.toAppError())
        }
    }
    
    func savePhotoAsFavorite(_ photo: Photo) -> Result<Bool, AppError> {
        do {
            try favDataSource.saveFavorite(photo)
            return .success(true)
        } catch {
            return .failure(error.toAppError())
        }
    }
    
    func deletePhotoAsFavorite(_ photo: Photo) -> Result<Bool, AppError> {
            do {
                try favDataSource.deleteFavorite(photo)
                return .success(true)
            } catch {
                return .failure(error.toAppError())
            }
        }

    func fetchFavoritePhotos() -> Result<[Photo], AppError> {
            do {
                let result = try favDataSource.fetchFavorites()
                return .success(result)
            } catch {
                return .failure(error.toAppError())
            }
        }
    
    func isPhotoFavorite(_ photo: Photo) -> Result<Bool, AppError> {
            do {
                return .success(try favDataSource.isFavorite(photo: photo))
            } catch {
                return .failure(error.toAppError())
            }
        }
    
    func fetchMyPhotos() -> Result<[Photo], AppError> {
            do {
                let result = try myPhotosDataSource.fetchMyPhotos()
                return .success(result)
            } catch {
                return .failure(error.toAppError())
            }
        }
    
    func saveMyPhoto(_ photo: Photo) -> Result<Bool, AppError> {
        do {
            try myPhotosDataSource.saveMyPhoto(photo)
            return .success(true)
        } catch {
            return .failure(error.toAppError())
        }
    }

}
