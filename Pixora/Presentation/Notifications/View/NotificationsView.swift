//
//  NotificationsView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct NotificationsView: View {
    @StateObject var viewModel = Resolver.shared.resolve(NotificationsViewModel.self)

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .initial, .loading:
                    ProgressView()
                case .success:
                    List(viewModel.actions, id: \.id) { action in
                        HStack {
                            if let data = action.photo.imageData, let uiImage = UIImage(
                                data: data
                            ) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(6)
                                    .clipped()
                            }  else {
                                WebImage(url: action.photo.imageURL)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(6)
                                    .clipped()
                            }
                            VStack(alignment: .leading) {
                                Text(actionMessage(for: action))
                                    .font(.body)
                                Text(action.timestamp.formatted(date: .abbreviated, time: .shortened))
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                case .empty:
                    InfoView(message: "No activity yet")
                case .error(let msg):
                    InfoView(message: msg)
                }
            }
            .navigationTitle("Activity")
        }
        .task {
            viewModel.loadActions()
        }
    }

    private func actionMessage(for action: UserActivity) -> String {
        switch action.type {
        case .likedPhoto:
            return "Has dado me gusta a una foto"
        case .addedToList:
            return "Has añadido una foto a la lista \(action.listName ?? "")"
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NotificationsView()
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("iPhone SE Portrait")

            NotificationsView()
                .previewDevice("iPhone 15")
                .previewDisplayName("iPhone 15")

            NotificationsView()
                .previewDevice("iPad Pro (11-inch) (4th generation)")
                .previewDisplayName("iPad Pro")
        }
    }
}


