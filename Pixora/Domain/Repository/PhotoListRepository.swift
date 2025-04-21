//
//  PhotoListRepository.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 17/4/25.
//

import Foundation

protocol PhotoListRepository {
    func getLists() -> Result<[PhotoList], AppError>
    func addList(name: String) -> Result<Bool, AppError>
    func addPhotoToList(_ photo: Photo, to list: PhotoList) -> Result<Bool, AppError>
    func isPhotoInAnyList(_ photo: Photo) -> Result<Bool, AppError>
    func getPhotosFromPhotoList(for list: PhotoList) -> Result<[Photo], AppError>
}

