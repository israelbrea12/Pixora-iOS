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
    @StateObject var photoDetailsViewModel = Resolver.shared.resolve(
        PhotoDetailsViewModel.self
    )
    
    @Environment(
        \.presentationMode
    ) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationStack{
            ZStack(
                content: {
                    switch photoDetailsViewModel.state{
                    case .loading,
                            .initial:
                        loadingView()
                    case .success:
                        successView()
                    case .error(let error):
                        errorView(errorMsg: error)
                    case .empty:
                        emptyView()
                    }
                }
            )
        }
        .task {
            let isAlreadyFavorite = await photoDetailsViewModel.load(photo: photo)
            if isAlreadyFavorite {
                photo.likes = (photo.likes ?? 0) + 1
            }
            photoDetailsViewModel.checkIfPhotoIsInAnyList(photo)
        }

    }
    
    private func loadingView() -> some View {
        ProgressView()
    }
    
    private func successView() -> some View{
        ScrollView{
            VStack {
                photoCoverImage
                            
                interactionBar
                            
                userInfo
                            
                descriptionView
                            
                Divider()
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                
                Spacer()
                
            }
            .padding(.horizontal, 4)
            .toolbar(.hidden, for: .navigationBar)
        } //ScrollView
        .scrollIndicators(.hidden)
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
    
    private func emptyView() -> some View {
        InfoView(message: "No data found")
    }
    
    private func errorView(errorMsg: String) -> some View {
        InfoView(message: errorMsg)
    }
    
    // 📸 Imagen de la foto ajustada al ancho
    private var photoCoverImage: some View {
        WebImage(url: photo.imageURL)
            .resizable()
            .scaledToFit() // Mantiene proporciones sin recortar
            .frame(maxWidth: .infinity)
            .cornerRadius(20)
            .overlay(backButton, alignment: .topLeading) // Botón de regresar
    }
        
    // 🔙 Botón para volver atrás
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
        
    // 📌 Barra de interacciones (Likes, Comentarios, Descargas, Más opciones, Guardar)
    private var interactionBar: some View {
        HStack(spacing: 18) {
            HStack {
                LikeButton(
                        isLiked: photoDetailsViewModel.isFavorite,
                        onTap: {
                            Task {
                                let liked = await photoDetailsViewModel.toggleFavorite(for: photo)
                                if liked {
                                    photo.likes = (photo.likes ?? 0) + 1
                                } else {
                                    photo.likes = max((photo.likes ?? 0) - 1, 0)
                                }
                            }
                        }
                    )

                Text("\(photoDetailsViewModel.likes)")
                    .font(.subheadline)
            }
                
            Button(action: {}) {
                Image(systemName: "message")
                    .foregroundColor(.black)
                    .font(.headline)
                    .bold()
            }
                
            Button(action: {}) {
                Image(systemName: "arrow.down.circle")
                    .foregroundColor(.black)
                    .font(.headline)
                    .bold()
            }
                
            Button(action: {}) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .font(.headline)
                    .bold()
            }
                
            Spacer()
                
            Button(action: {
                photoDetailsViewModel.isNewListSheetPresented = true
            }) {
                Text(photoDetailsViewModel.isSavedInAnyList ? "Guardado" : "Guardar")
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10)
                    .font(.body)
                    .bold()
                    .background(photoDetailsViewModel.isSavedInAnyList ? Color.gray : Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(24)
            }
            .sheet(isPresented: $photoDetailsViewModel.isNewListSheetPresented, onDismiss: {
                photoDetailsViewModel.checkIfPhotoIsInAnyList(photo)
            }) {
                NewListView(photo: photo)
            }
        }
        .font(.title3)
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
    }
        
    // 🏅 Usuario (Foto de perfil + Nombre)
    private var userInfo: some View {
        HStack {
            WebImage(url: photo.photographerProfileImage)
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                
            Text(photo.photographerUsername ?? "Unknown")
                .font(.headline)
                
            Spacer()
        }
        .padding(.horizontal)
    }
        
    // 📝 Descripción de la imagen
    private var descriptionView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(photo.description ?? "No description available.")
                .font(.body)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.top, 4)
    }
}


