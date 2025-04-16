//
//  LikeButton.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 16/4/25.
//

import SwiftUI

struct LikeButton: View {
    var isLiked: Bool
    var onTap: () -> Void

    @State private var animate: Bool = false

    var body: some View {
        ZStack {
            heartImage(systemName: "heart.fill", show: isLiked)
            heartImage(systemName: "heart", show: !isLiked)
        }
        .onTapGesture {
            animate = true
            onTap()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animate = false
            }
        }
    }

    @ViewBuilder
    private func heartImage(systemName: String, show: Bool) -> some View {
        Image(systemName: systemName)
            .foregroundColor(systemName == "heart.fill" ? .red : .black)
            .scaleEffect(show && animate ? 1.3 : (show ? 1 : 0))
            .opacity(show ? 1 : 0)
            .bold()
            .animation(.interpolatingSpring(stiffness: 170, damping: 15), value: show)
            .animation(.easeOut(duration: 0.2), value: animate)
    }
}

