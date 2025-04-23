//
//  MyPhotosViewModel.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/4/25.
//

import Foundation
import SwiftUI
import CoreData

class MyPhotosViewModel: ObservableObject {
    @Published var photos: [PhotoEntity] = []

    private var context: NSManagedObjectContext {
        PersistenceController.shared.container.viewContext
    }

    init() {
        fetchPhotos()
    }

    func fetchPhotos() {
        let request: NSFetchRequest<PhotoEntity> = PhotoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "imageData != nil")

        do {
            photos = try context.fetch(request)
        } catch {
            print("❌ Error al cargar fotos: \(error)")
        }
    }
}
