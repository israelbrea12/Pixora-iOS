//
//  AddMyPhotoView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 22/4/25.
//

import SwiftUI
import PhotosUI

struct AddMyPhotoView: View {
    @StateObject private var viewModel = AddMyPhotoViewModel()
    @State private var isNavigatingToForm = false

    var body: some View {
        NavigationStack {
            VStack {
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .cornerRadius(25)
                } else {
#if DEBUG
                    Image("placeholderImage")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .cornerRadius(25)
#endif
                }

                Button(action: {
                    viewModel.showingCamera = true
                }) {
                    Text("Take Photo")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(25)
                }
                .sheet(isPresented: $viewModel.showingCamera) {
                    CameraView(image: $viewModel.selectedImage)
                }

                PhotosPicker(selection: $viewModel.selectedItem,
                             matching: .images,
                             photoLibrary: .shared()) {
                    Text("Select Photo")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }

                Button("Siguiente") {
                    isNavigatingToForm = true
                }
                .disabled(viewModel.selectedImage == nil)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(25)
            }
            .padding()
            .navigationDestination(isPresented: $isNavigatingToForm) {
                PhotoFormView(image: viewModel.selectedImage)
            }
        }
    }
}

#Preview {
    AddMyPhotoView()
}
