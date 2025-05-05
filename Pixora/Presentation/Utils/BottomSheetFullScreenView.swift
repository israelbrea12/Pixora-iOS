//
//  BottomSheetFullScreenView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 5/5/25.
//

import SwiftUI

struct BottomSheetFullScreenView: View {
    var onImageSelected: (UIImage) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            BottomSheetView(onImageSelected: onImageSelected)
                .navigationTitle("Nueva foto")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cerrar") {
                            dismiss()
                        }
                    }
                }
        }
    }
}

