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
}


