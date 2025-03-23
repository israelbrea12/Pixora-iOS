//
//  InfoView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import SwiftUI

struct InfoView: View {
    let message: String
    
    var body: some View {
        VStack{
            Spacer()
            Text(message)
                .font(.title)
                .fontWeight(.bold)
            Spacer()
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(message: "info message")
    }
}
