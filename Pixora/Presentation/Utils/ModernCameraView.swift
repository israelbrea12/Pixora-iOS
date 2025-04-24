//
//  CameraView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 22/4/25.
//


import SwiftUI
import AVFoundation

struct ModernCameraView: View {
    @Binding var image: UIImage?
    @Environment(\.dismiss) private var dismiss
    @StateObject private var cameraManager = CameraManager()
    @State private var capturedImage: UIImage?

    var body: some View {
        ZStack {
            if let previewImage = capturedImage {
                Image(uiImage: previewImage)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()

                    HStack {
                        Button("Repetir") {
                            capturedImage = nil
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.black.opacity(0.7))
                        .clipShape(Capsule())

                        Spacer()

                        Button("Usar foto") {
                            image = previewImage
                            dismiss()
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.accentColor)
                        .clipShape(Capsule())
                    }
                    .padding(.horizontal, 120) // MÁS ESPACIO
                    .padding(.bottom, 40)
                }


            } else {
                CameraPreview(session: cameraManager.session)
                    .ignoresSafeArea()

                VStack {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .padding()
                        }

                        Spacer()
                    }

                    Spacer()

                    HStack(alignment: .center) {
                        Spacer()

                        Button(action: {
                            cameraManager.switchCamera()
                        }) {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .padding(.trailing, 40)
                        }
                    }
                    .padding(.bottom, 40)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        Button(action: {
                            cameraManager.capturePhoto { newImage in
                                if let newImage = newImage {
                                    capturedImage = newImage
                                }
                            }
                        }) {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 70, height: 70)
                                .overlay(Circle().stroke(Color.black, lineWidth: 2))
                                .padding(.bottom, 40)
                        }
                    )
                }
            }
        }
        .onAppear {
            cameraManager.configure()
        }
        .onDisappear {
            cameraManager.stopSession()
        }
    }
}


struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

class CameraManager: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    let session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    private var photoCaptureCompletion: ((UIImage?) -> Void)?
    private var currentInput: AVCaptureDeviceInput?
    private var currentCameraPosition: AVCaptureDevice.Position = .back

    func configure() {
        session.beginConfiguration()
        session.sessionPreset = .photo

        guard let device = camera(for: currentCameraPosition),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else {
            print("Failed to set up camera input")
            return
        }

        if session.canAddOutput(output) {
            session.addInput(input)
            session.addOutput(output)
            currentInput = input
        }

        session.commitConfiguration()
        session.startRunning()
    }

    func stopSession() {
        session.stopRunning()
    }

    func capturePhoto(completion: @escaping (UIImage?) -> Void) {
        let settings = AVCapturePhotoSettings()
        self.photoCaptureCompletion = completion
        output.capturePhoto(with: settings, delegate: self)
    }

    func switchCamera() {
        guard let currentInput = currentInput else { return }
        session.beginConfiguration()
        session.removeInput(currentInput)

        currentCameraPosition = (
            currentCameraPosition == .back
        ) ? .front : .back

        if let newDevice = camera(for: currentCameraPosition),
           let newInput = try? AVCaptureDeviceInput(device: newDevice),
           session.canAddInput(newInput) {
            session.addInput(newInput)
            self.currentInput = newInput
        } else {
            session.addInput(currentInput) // fallback
        }

        session.commitConfiguration()
    }

    private func camera(for position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: position
        ).devices.first
    }

    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        guard let data = photo.fileDataRepresentation(), let uiImage = UIImage(data: data) else {
            photoCaptureCompletion?(nil)
            return
        }
        photoCaptureCompletion?(uiImage)
    }
}
