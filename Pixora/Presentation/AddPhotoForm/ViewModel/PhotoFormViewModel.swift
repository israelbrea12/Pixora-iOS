//
//  PhotoFormViewModel.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/4/25.
//

import SwiftUI

@MainActor
class PhotoFormViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var description: String = ""
    @Published var photographerUsername: String = ""

    private let saveMyPhotoUseCase: SaveMyPhotoUseCase

    init(saveMyPhotoUseCase: SaveMyPhotoUseCase) {
        self.saveMyPhotoUseCase = saveMyPhotoUseCase
    }

    func setImage(_ image: UIImage) {
        print("🧩 Imagen actualizada: \(image)")
        self.image = image
    }

    func savePhoto() {
        guard let image = image else { return }

        let photo = Photo(
            id: UUID().uuidString,
            description: description,
            color: "#FFFFFF",
            likes: 0,
            imageURL: nil,
            photographerUsername: photographerUsername,
            photographerProfileImage: nil,
            isFavorite: false,
            imageData: image.jpegData(compressionQuality: 0.8)
        )

        let result = saveMyPhotoUseCase.execute(photo: photo)
        switch result {
        case .success:
            print("✅ Foto guardada.")
        case .failure(let error):
            print("❌ Error al guardar: \(error.localizedDescription)")
        }
    }
    func reset() {
        image = nil
        description = ""
        photographerUsername = ""
    }

}
