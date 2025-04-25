//
//  SplashView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 25/4/25.
//


import SwiftUI

struct SplashView: View {
    @Binding var isActive: Bool

    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            LottieView(fileName: "lottie_p_animation")
                .frame(width: 150, height: 150)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    isActive = false
                }
            }
        }
    }
}
