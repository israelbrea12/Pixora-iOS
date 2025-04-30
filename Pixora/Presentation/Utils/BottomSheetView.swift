//
//  BottomSheetView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 24/4/25.
//

import SwiftUI
import PhotosUI

struct BottomSheetView: View {
    var onImageSelected: (UIImage) -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var showingCamera = false
    @State private var tempImage: UIImage?

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                
                Text("Nueva foto")
                    .font(.headline)
                    .padding(.top, 8)
                
                VStack(spacing: 16) {
                    Button {
                        checkCameraPermission { granted in
                            if granted {
                                showingCamera = true
                            } else {
                                // Muestra alerta para que active permisos
                            }
                        }
                    } label: {
                        sheetButton(icon: "camera.fill", title: "Desde cámara")
                    }
                    
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        sheetButton(icon: "photo.on.rectangle", title: "Desde galería")
                    }
                    
                    .onChange(of: selectedItem) { newItem in
                        guard let newItem = newItem else { return }
                        Task {
                            if let data = try? await newItem.loadTransferable(type: Data.self),
                               let image = UIImage(data: data) {
                                onImageSelected(image)
                                dismiss()
                            }
                        }
                    }
                }
                
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 16)
        .background(Color(.systemBackground).ignoresSafeArea(edges: .bottom))
        .sheet(isPresented: $showingCamera, onDismiss: {
            if let image = tempImage {
                onImageSelected(image)
                dismiss()
            }
        }) {
            ModernCameraView(image: $tempImage)
        }
    }

    func sheetButton(icon: String, title: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(LinearGradient.mainBluePurple)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Text(title)
                .font(.body)
                .foregroundColor(.primary)

            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

