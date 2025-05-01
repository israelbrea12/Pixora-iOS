//
//  GradientBackground.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 30/4/25.
//


import SwiftUI

struct GradientBackground: View {
    
    var body: some View {
        
        LinearGradient(
            gradient: Gradient(colors: [Color.blue, Color.purple]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
