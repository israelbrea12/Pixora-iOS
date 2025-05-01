//
//  PhotoListRepositoryImpl.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 17/4/25.
//

import Foundation

class PhotoListRepositoryImpl: PhotoListRepository {
    
    private let dataSource: PhotoListDataSource

    init(dataSource: PhotoListDataSource) {
        self.dataSource = dataSource
    }

    func getLists() -> Result<[PhotoList], AppError> {
        do {
            let lists = try dataSource.fetchLists()
            return .success(lists)
        } catch {
            return .failure(error.toAppError())
        }
    }

    func addList(name: String) -> Result<Bool, AppError> {
        do {
            try dataSource.createList(name: name)
            return .success(true)
        } catch {
            return .failure(error.toAppError())
        }
    }
    
    func addPhotoToList(_ photo: Photo, to list: PhotoList) -> Result<Bool, AppError> {
        do {
            try dataSource.addPhotoToList(photo, to: list)
            return .success(true)
        } catch {
            return .failure(error.toAppError())
        }
    }
    
    func isPhotoInAnyList(_ photo: Photo) -> Result<Bool, AppError> {
        do {
            let lists = try dataSource.fetchLists()
            let isInList = lists.contains { list in
                let photos = try? dataSource.getPhotos(for: list)
                return photos?.contains(where: { $0.id == photo.id }) ?? false
            }
            return .success(isInList)
        } catch {
            return .failure(error.toAppError())
        }
    }
    
    func getPhotosFromPhotoList(for list: PhotoList) -> Result<[Photo], AppError> {
        do {
            let photos = try dataSource.getPhotos(for: list)
            return .success(photos)
        } catch {
            return .failure(error.toAppError())
        }
    }
}


