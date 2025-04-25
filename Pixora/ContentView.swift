//
//  ContentView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var showSplash = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashView(isActive: $showSplash)
            } else {
                MainView()
            }
        }
    }
}

#Preview {
    ContentView()
}

