//
//  AddPhotoFormView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/4/25.
//

import SwiftUI

struct PhotoFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: PhotoFormViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .cornerRadius(25)
                }

                TextField("Descripción", text: $viewModel.description)
                    .textFieldStyle(.roundedBorder)

                TextField("Color (#RRGGBB)", text: $viewModel.color)
                    .textFieldStyle(.roundedBorder)

                TextField("Usuario", text: $viewModel.photographerUsername)
                    .textFieldStyle(.roundedBorder)

                Button("Guardar") {
                    viewModel.savePhoto()
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(25)
            }
            .padding()
        }
        .navigationTitle("Nueva Foto")
    }
}

