//
//  AddPhotoFormView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/4/25.
//

import SwiftUI

struct PhotoFormView: View {
    
    @StateObject private var photoFormViewModel = Resolver.shared.resolve(PhotoFormViewModel.self)
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var mainViewModel: MainViewModel

    let image: UIImage

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let image = photoFormViewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(25)
                }

                TextField("Description", text: $photoFormViewModel.description)
                    .textFieldStyle(.roundedBorder)

                TextField("User", text: $photoFormViewModel.photographerUsername)
                    .textFieldStyle(.roundedBorder)

                Button {
                            photoFormViewModel.savePhoto()
                            presentationMode.wrappedValue.dismiss()

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                mainViewModel.shouldNavigateToMyPhotos = true
                            }
                } label: {
                    Text("Save")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient.mainBluePurple)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                }
            }
            .padding()
        }
        .navigationTitle("New Photo")
        .onAppear {
            photoFormViewModel.setImage(image)
        }
        .onDisappear {
            photoFormViewModel.image = nil
            photoFormViewModel.description = ""
            photoFormViewModel.photographerUsername = ""
        }
    }
}

