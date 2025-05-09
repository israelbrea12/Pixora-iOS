//
//  PhotoDetailsView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 28/3/25.
//

import SwiftUI
import Swinject
import SDWebImageSwiftUI

struct PhotoDetailsView: View {
    
    @State var photo: Photo
    
    @StateObject var photoDetailsViewModel = Resolver.shared.resolve(PhotoDetailsViewModel.self)
    
    @EnvironmentObject var tabBarVisibility: TabBarVisibilityManager

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            switch photoDetailsViewModel.state {
            case .loading, .initial:
                loadingView()
            case .success:
                successView()
            case .error(let error):
                errorView(errorMsg: error)
            case .empty:
                emptyView()
            }

            backButton
                .padding(.leading, 16)
                .padding(.top, 16)
        }
        .task {
            let isAlreadyFavorite = await photoDetailsViewModel.load(
                photo: photo
            )
            if isAlreadyFavorite {
                photoDetailsViewModel.likes += 1
            }
            photoDetailsViewModel.checkIfPhotoIsInAnyList(photo)
        }
        .onAppear {
            tabBarVisibility.hide()
        }
        .onDisappear {
            tabBarVisibility.show()
        }

    }

    
    private func loadingView() -> some View {
        ProgressView()
    }
    
    private func successView() -> some View{
        ScrollView{
            VStack {
                VStack(spacing: 16) {
                    photoCoverImage
                    interactionBar
                }
                .frame(maxWidth: 600)
                .padding(.horizontal)
                            
                userInfo
                            
                descriptionView
                            
                Divider()
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                
                Spacer()
                
            }
            .padding(.horizontal, 4)
            .toolbar(.hidden, for: .navigationBar)
        }
        .scrollIndicators(.hidden)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
    
    private func emptyView() -> some View {
        InfoView(message: "No data found")
    }
    
    private func errorView(errorMsg: String) -> some View {
        InfoView(message: errorMsg)
    }
    
    private var photoCoverImage: some View {
        Group {
            if let data = photo.imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
            } else if let url = photo.imageURL {
                WebImage(url: url)
                    .resizable()
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .foregroundColor(.gray)
            }
        }
        .scaledToFit()
        .cornerRadius(20)
        .frame(maxWidth: .infinity)
        .onTapGesture(count: 2) {
                Task {
                    _ = await photoDetailsViewModel.toggleFavorite(for: photo)
                }
            }
    }

    private var backButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .font(.title2)
                .padding()
                .background(Color.white.opacity(0.8))
                .clipShape(Circle())
                .foregroundColor(.black)
        }
        .padding(.leading, 16)
        .padding(.top, 16)
    }

    private var interactionBar: some View {
        HStack(spacing: 18) {
            HStack {
                LikeButton(
                    isLiked: photoDetailsViewModel.isFavorite,
                    onTap: {
                        Task {
                            _ = await photoDetailsViewModel
                                .toggleFavorite(for: photo)
                        }
                    }
                )

                Text("\(photoDetailsViewModel.likes)")
                    .font(.subheadline)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .minimumScaleFactor(0.6)
            }
                
//            Button(action: {}) {
//                Image(systemName: "message")
//                    .foregroundColor(.black)
//                    .font(.headline)
//                    .bold()
//            }
//                
//            Button(action: {}) {
//                Image(systemName: "arrow.down.circle")
//                    .foregroundColor(.black)
//                    .font(.headline)
//                    .bold()
//            }
//                
//            Button(action: {}) {
//                Image(systemName: "ellipsis")
//                    .foregroundColor(.black)
//                    .padding(.horizontal)
//                    .font(.headline)
//                    .bold()
//            }
                
            Spacer()
                
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                    photoDetailsViewModel.isNewListSheetPresented = true
                }
            }) {
                Text(
                    photoDetailsViewModel.isSavedInAnyList ? "Saved" : "Save"
                )
                .lineLimit(1)
                .truncationMode(.tail)
                .minimumScaleFactor(0.6)
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .font(.body)
                .bold()
                .background(
                    photoDetailsViewModel.isSavedInAnyList ? Color.gray : Color.red
                )
                .foregroundColor(.white)
                .cornerRadius(24)
                .animation(
                    .spring(response: 0.3, dampingFraction: 0.5),
                    value: photoDetailsViewModel.isSavedInAnyList
                )
            }
            .sheet(isPresented: $photoDetailsViewModel.isNewListSheetPresented, onDismiss: {
                photoDetailsViewModel.checkIfPhotoIsInAnyList(photo)
            }) {
                NewListView(photo: photo)
            }
        }
        .font(.title3)
        .padding(.vertical, 10)
    }

    private var userInfo: some View {
        HStack {
            WebImage(url: photo.photographerProfileImage) { phase in
                switch phase {
                case .empty:
                    initialsCircle
                        .foregroundColor(.black)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipped()
                        .clipShape(Circle())
                case .failure:
                    initialsCircle
                @unknown default:
                    initialsCircle
                }
            }
                
            Text(photo.photographerUsername ?? "Unknown")
                .font(.headline)
                
            Spacer()
        }
        .padding(.horizontal)
    }

    private var descriptionView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(photo.description ?? "No description available.")
                .font(.body)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.top, 4)
    }
    
    private var initialsCircle: some View {
        let initials = (photo.photographerUsername ?? "U").initials
        return Text(initials)
            .font(.headline)
            .foregroundColor(.white)
            .frame(width: 40, height: 40)
            .background(Circle().fill(Color.gray))
    }
}


