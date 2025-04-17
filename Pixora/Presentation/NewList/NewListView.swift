//
//  NewListView.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 17/4/25.
//

import SwiftUI

struct NewListView: View {
    let photoID: String
    @Environment(\.dismiss) var dismiss
    @StateObject var newListViewModel = Resolver.shared.resolve(
        NewListViewModel.self
    )
    
    var body: some View {
        NavigationStack {
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
        .alert("Nueva lista", isPresented: $newListViewModel.showCreateAlert) {
            TextField("Nombre de la lista", text: $newListViewModel.newListName)
            Button("Añadir", action: newListViewModel.createList)
            Button("Cancelar", role: .cancel) {}
        } message: {
            Text("Escribe un nombre para la nueva lista")
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
            ForEach(newListViewModel.lists) { list in
                ListCellView(
                    name: list.name,
                    action: {
                        newListViewModel.save(photoID: photoID, to: list)
                        dismiss()
                    }
                )
            }
        }
        .listStyle(.plain)
    }
}


struct ListCellView: View {
    let name: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(name)
                    .foregroundColor(.primary)

                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
    }
}
