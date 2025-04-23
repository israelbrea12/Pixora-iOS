//
//  AddMyPhotoViewModel.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 22/4/25.
//

import SwiftUI
import PhotosUI

@MainActor
class AddMyPhotoViewModel: ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var showingCamera = false
    @Published var selectedItem: PhotosPickerItem? {
        didSet {
            loadImageFromPicker()
        }
    }

    func loadImageFromPicker() {
        guard let item = selectedItem else { return }
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.selectedImage = image
                }
            }
        }
    }

    func setImageFromCamera(_ image: UIImage?) {
        selectedImage = image
    }
}


