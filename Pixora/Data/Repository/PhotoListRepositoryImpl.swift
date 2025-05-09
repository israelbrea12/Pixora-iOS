//
//  PhotoListRepositoryImpl.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 17/4/25.
//

import Foundation
import CoreData

class PhotoListRepositoryImpl: PhotoListRepository {

    private let dataSource: PhotoListDataSource
    private let context: NSManagedObjectContext

    init(
        dataSource: PhotoListDataSource,
        context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    ) {
        self.dataSource = dataSource
        self.context = context
    }

    func getLists() -> Result<[PhotoList], AppError> {
        do {
            let listEntities = try dataSource.fetchListEntities()
            return .success(listEntities.map { $0.toDomain() })
        } catch {
            return .failure(error.toAppError())
        }
    }

    func addList(name: String) -> Result<Bool, AppError> {
        do {
            let newListDomainModel = PhotoList(id: UUID(), name: name)
            let listEntity = newListDomainModel.toData(context: self.context)
            try dataSource.createListEntity(listEntity)
            return .success(true)
        } catch {
            return .failure(error.toAppError())
        }
    }

    func addPhotoToList(_ photo: Photo, to list: PhotoList) -> Result<Bool, AppError> {
        do {
            let photoEntity = photo.toData(context: self.context)
            try dataSource.addPhotoEntity(photoEntity, toListEntityWithId: list.id)
            return .success(true)
        } catch {
            return .failure(error.toAppError())
        }
    }

    func isPhotoInAnyList(_ photo: Photo) -> Result<Bool, AppError> {
        do {
            guard let photoIdToCheck = photo.id else {
                 return .failure(AppError.unknownError("Photo ID is nil, cannot check if in any list."))
            }
            let listEntities = try dataSource.fetchListEntities()
            for listEntity in listEntities {
                // Asegúrate que listEntity.id sea del tipo correcto (UUID)
                let photoEntitiesInList = try dataSource.getPhotoEntities(forListEntityWithId: listEntity.id ?? UUID())
                if photoEntitiesInList.contains(where: { $0.id == photoIdToCheck }) {
                    return .success(true)
                }
            }
            return .success(false)
        } catch {
            return .failure(error.toAppError())
        }
    }

    func getPhotosFromPhotoList(for list: PhotoList) -> Result<[Photo], AppError> {
        do {
            let photoEntities = try dataSource.getPhotoEntities(forListEntityWithId: list.id)
            return .success(photoEntities.map { $0.toDomain() })
        } catch {
            return .failure(error.toAppError())
        }
    }
}
