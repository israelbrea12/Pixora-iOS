//
//  AddPhotoFormView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/4/25.
//

import SwiftUI

struct PhotoFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var photoFormViewModel: PhotoFormViewModel

    init(image: UIImage?) {
        print("📷 Recibida imagen en PhotoFormView: \(String(describing: image))")
        _photoFormViewModel = StateObject(
            wrappedValue: Resolver.shared
                .resolve(PhotoFormViewModel.self, argument: image)
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let image = photoFormViewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .cornerRadius(25)
                }

                TextField("Descripción", text: $photoFormViewModel.description)
                    .textFieldStyle(.roundedBorder)

                TextField(
                    "Usuario",
                    text: $photoFormViewModel.photographerUsername
                )
                .textFieldStyle(.roundedBorder)

                Button {
                    photoFormViewModel.savePhoto()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Guardar")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
                
            }
            .padding()
        }
        .navigationTitle("Nueva Foto")

    }
}

