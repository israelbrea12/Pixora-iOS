//
//  AddMyPhotoView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 22/4/25.
//

import SwiftUI
import PhotosUI
import AVFoundation

struct AddMyPhotoView: View {
    @StateObject private var viewModel = AddMyPhotoViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            ZStack {
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .ignoresSafeArea()
                } else {
                    CameraPreview(session: viewModel.captureSession)
                        .ignoresSafeArea()
                        .onAppear {
                            viewModel.startCamera()
                        }
                }

                VStack {
                    HStack {
                        Button {
                            viewModel.showGalleryPicker = true
                        } label: {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.system(size: 24, weight: .bold))
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }

                        Spacer()

                        Button {
                            viewModel.takePhoto()
                        } label: {
                            Image(systemName: "circle")
                                .font(.system(size: 70))
                                .foregroundColor(.white)
                                .padding(.bottom, 8)
                        }

                        Spacer()

                        Button {
                            viewModel.switchCamera()
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .font(.system(size: 24, weight: .bold))
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }
                    }
                    .padding()
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .photosPicker(isPresented: $viewModel.showGalleryPicker,
                          selection: $viewModel.photoItem,
                          matching: .images)
        }
    }
}
