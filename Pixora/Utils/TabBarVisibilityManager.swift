//
//  TabBarVisibility.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 21/4/25.
//

import SwiftUI

final class TabBarVisibilityManager: ObservableObject {
    @Published var isVisible: Bool = true

    func show() {
        withAnimation {
            isVisible = true
        }
    }

    func hide() {
        withAnimation {
            isVisible = false
        }
    }
}


