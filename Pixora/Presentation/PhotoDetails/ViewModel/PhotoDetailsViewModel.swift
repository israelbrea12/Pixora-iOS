//
//  PhotoDetailsViewModel.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 28/3/25.
//

import Foundation

@MainActor
final class PhotoDetailsViewModel : ObservableObject {
    @Published var state: ViewState = .success
    private let offset: Int = 0
    
}
