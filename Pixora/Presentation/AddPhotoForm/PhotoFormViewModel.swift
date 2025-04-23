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
    @Published var color: String = "#FFFFFF"
    @Published var photographerUsername: String = ""

    init(image: UIImage?) {
        self.image = image
    }

    func savePhoto() {
        guard let image = image else { return }
        let context = PersistenceController.shared.container.viewContext
        let newPhoto = PhotoEntity(context: context)
        newPhoto.id = UUID().uuidString
        newPhoto.descriptionText = description
        newPhoto.color = color
        newPhoto.photographerUsername = photographerUsername
        newPhoto.isFavorite = false
        newPhoto.imageData = image.jpegData(compressionQuality: 0.8)
        
        do {
            try context.save()
            print("✅ Foto guardada en CoreData.")
        } catch {
            print("❌ Error al guardar: \(error)")
        }
    }
}
