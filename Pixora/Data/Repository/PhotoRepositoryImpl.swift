//
//  PhotoRepositoryImpl.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation
import CoreData

class PhotoRepositoryImpl: PhotoRepository {

    private let photoDataSource: PhotoDataSource
    private let favDataSource: FavoritePhotoDataSource
    private let myPhotosDataSource: MyPhotosDataSource
    private let context: NSManagedObjectContext

    init(
        photoDataSource: PhotoDataSource,
        favDataSource: FavoritePhotoDataSource,
        myPhotosDataSource: MyPhotosDataSource,
        context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    ) {
        self.photoDataSource = photoDataSource
        self.favDataSource = favDataSource
        self.myPhotosDataSource = myPhotosDataSource
        self.context = context
    }

    func getPhotos(from page: Int, by query: String) async -> Result<[Photo], AppError> {
        do {
            let photosData = try await photoDataSource.getPhotos(from: page, by: query)
            return .success(photosData.results?.map { $0.toDomain() } ?? [])
        } catch {
            return .failure(error.toAppError())
        }
    }

    func savePhotoAsFavorite(_ photo: Photo) -> Result<Bool, AppError> {
        do {
            var photoToSave = photo
            photoToSave.isFavorite = true

            let photoEntity = photoToSave.toData(context: self.context)

            try favDataSource.saveFavoriteEntity(photoEntity)
            return .success(true)
        } catch {
            return .failure(error.toAppError())
        }
    }

    func deletePhotoAsFavorite(_ photo: Photo) -> Result<Bool, AppError> {
        do {
            guard let photoId = photo.id else {
                return .failure(AppError.unknownError("Photo ID is nil, cannot delete favorite."))
            }
            try favDataSource.deleteFavoriteEntityBy(photoId: photoId)
            return .success(true)
        } catch {
            return .failure(error.toAppError())
        }
    }

    func fetchFavoritePhotos() -> Result<[Photo], AppError> {
        do {
            // 1. Obtener entidades del DataSource
            let favoriteEntities = try favDataSource.fetchFavoriteEntities()
            // 2. Convertir entidades a modelos de dominio
            return .success(favoriteEntities.map { $0.toDomain() })
        } catch {
            return .failure(error.toAppError())
        }
    }

    func isPhotoFavorite(_ photo: Photo) -> Result<Bool, AppError> {
        do {
            guard let photoId = photo.id else {
                return .failure(AppError.unknownError("Photo ID is nil, cannot check favorite status."))
            }
            let isFav = try favDataSource.isFavorite(photoId: photoId)
            return .success(isFav)
        } catch {
            return .failure(error.toAppError())
        }
    }

    func fetchMyPhotos() -> Result<[Photo], AppError> {
        do {
            let resultEntities = try myPhotosDataSource.fetchMyPhotos()
            return .success(resultEntities.map { $0.toDomain() })
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
