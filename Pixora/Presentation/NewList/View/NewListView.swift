//
//  NewListView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 17/4/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct NewListView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var newListViewModel = Resolver.shared.resolve(
        NewListViewModel.self
    )

    var photo: Photo

    var body: some View {
        NavigationStack {
            ZStack {
                switch newListViewModel.state {
                case .initial, .loading:
                    loadingView()
                case .success:
                    contentView()
                case .empty:
                    InfoView(message: "Aún no tienes listas creadas")
                case .error(let errorMsg):
                    InfoView(message: errorMsg)
                }
            }
        }
        .alert("Nueva lista", isPresented: $newListViewModel.showCreateAlert) {
            TextField("Nombre de la lista", text: $newListViewModel.newListName)
                .disableAutocorrection(true)
            Button("Añadir", action: newListViewModel.createList)
            Button("Cancelar", role: .cancel) {}
        } message: {
            Text("Escribe un nombre para la nueva lista")
        }
        .onAppear {
            Task {
                newListViewModel.loadLists()
            }
        }
    }

    private func loadingView() -> some View {
        ProgressView()
    }

    private func contentView() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            header
            createListButton
            listSection
            Spacer()
        }
        .padding()
        .navigationTitle("Guardar")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cerrar") {
                    dismiss()
                }
            }
        }
    }

    private var header: some View {
        Text("Guardar en una lista")
            .font(.title2)
            .bold()
            .padding(.top)
    }

    private var createListButton: some View {
        Button {
            newListViewModel.showCreateAlert = true
        } label: {
            Label("Crear nueva lista", systemImage: "plus.circle.fill")
                .font(.headline)
                .foregroundColor(.blue)
                .padding(.vertical, 10)
        }
    }

    private var listSection: some View {
        List {
            ForEach(newListViewModel.listsWithPhotos, id: \.0.id) { (
                list,
                photos
            ) in
                Button {
                    newListViewModel.addPhoto(photo, to: list)
                    dismiss()
                } label: {
                    HStack(spacing: 12) {
                        if let lastPhoto = photos.last {
                            if let data = lastPhoto.imageData, let uiImage = UIImage(
                                data: data
                            ) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 44, height: 44)
                                    .clipped()
                                    .cornerRadius(8)
                            } else if let url = lastPhoto.imageURL {
                                WebImage(url: url)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 44, height: 44)
                                    .clipped()
                                    .cornerRadius(8)
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 44, height: 44)
                                    .cornerRadius(8)
                            }
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 44, height: 44)
                                .cornerRadius(8)
                        }

                        Text(list.name)
                            .foregroundColor(.primary)
                    }
                    .padding(.vertical, 6)
                }
            }
        }
        .listStyle(.plain)
    }
}
