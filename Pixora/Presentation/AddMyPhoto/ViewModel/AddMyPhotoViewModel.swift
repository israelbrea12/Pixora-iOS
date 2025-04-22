//
//  AddMyPhotoViewModel.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 22/4/25.
//

import SwiftUI
import AVFoundation
import PhotosUI

enum CameraPosition {
    case front
    case back
}

final class AddMyPhotoViewModel: NSObject, ObservableObject {
    @Published var selectedImage: UIImage?
    @Published var showGalleryPicker = false
    @Published var photoItem: PhotosPickerItem? {
        didSet {
            loadPhotoFromPicker()
        }
    }

    let captureSession = AVCaptureSession()
    
    private var output = AVCapturePhotoOutput()
    private var cameraPosition: CameraPosition = .back
    private var input: AVCaptureDeviceInput?

    func startCamera() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                setupCamera()
            case .notDetermined:
                let granted = await AVCaptureDevice.requestAccess(for: .video)
                if granted { setupCamera() }
            default: break
            }
        }
    }

    func switchCamera() {
            cameraPosition = (cameraPosition == .back) ? .front : .back
            setupCamera()
        }

    private func setupCamera() {
        if captureSession.isRunning {
            captureSession.stopRunning()
        }

        captureSession.beginConfiguration()

        // Eliminar entradas anteriores
        for input in captureSession.inputs {
            captureSession.removeInput(input)
        }

        // Eliminar salidas anteriores
        for output in captureSession.outputs {
            captureSession.removeOutput(output)
        }

        let device: AVCaptureDevice?

        if cameraPosition == .front {
            device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        } else {
            device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        }

        guard let device = device,
              let input = try? AVCaptureDeviceInput(device: device) else {
            captureSession.commitConfiguration()
            return
        }

        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }

        output = AVCapturePhotoOutput()
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }

        captureSession.commitConfiguration()
        captureSession.startRunning()
    }


    func takePhoto() {
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }

    private func loadPhotoFromPicker() {
        guard let item = photoItem else { return }

        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                await MainActor.run {
                    self.selectedImage = uiImage
                    saveImage(uiImage)
                }
            }
        }
    }

    private func saveImage(_ image: UIImage) {
        guard let jpegData = image.jpegData(compressionQuality: 0.9) else { return }
        let filename = UUID().uuidString + ".jpg"
        let url = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(filename)

        do {
            try jpegData.write(to: url!)
            print("✅ Imagen guardada en: \(url!)")
            // Aquí puedes guardar el `Photo` en CoreData si quieres
        } catch {
            print("❌ Error guardando la imagen:", error)
        }
    }
}

extension AddMyPhotoViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else { return }

        selectedImage = image
        saveImage(image)
    }
}

