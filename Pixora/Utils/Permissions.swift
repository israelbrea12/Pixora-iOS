//
//  Permissions.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 24/4/25.
//

import Photos

func checkPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
    let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
    switch status {
    case .notDetermined:
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
            DispatchQueue.main.async {
                completion(newStatus == .authorized || newStatus == .limited)
            }
        }
    case .authorized, .limited:
        completion(true)
    case .denied, .restricted:
        completion(false)
    @unknown default:
        completion(false)
    }
}


func checkCameraPermission(completion: @escaping (Bool) -> Void) {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
        completion(true)
    case .notDetermined:
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    case .denied, .restricted:
        completion(false)
    @unknown default:
        completion(false)
    }
}


