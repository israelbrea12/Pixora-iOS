//
//  ListCellView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 17/4/25.
//

import SwiftUI

struct ListCellView: View {
    let name: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(name)
                    .foregroundColor(.primary)

                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    ListCellView(name: "Tatuajes", action: {})
}
