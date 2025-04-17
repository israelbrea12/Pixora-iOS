//
//  NewListViewModel.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 17/4/25.
//

import Foundation

@MainActor
final class NewListViewModel: ObservableObject {
    @Published var lists: [PhotoList] = []
    @Published var newListName: String = ""
    @Published var showCreateAlert: Bool = false
    @Published var state: ViewState = .initial

    private let getListsUseCase: GetPhotoListsUseCase
    private let createListUseCase: CreatePhotoListUseCase

    init(
        getListsUseCase: GetPhotoListsUseCase,
        createListUseCase: CreatePhotoListUseCase
    ) {
        self.getListsUseCase = getListsUseCase
        self.createListUseCase = createListUseCase
        loadLists()
    }

    func loadLists() {
        state = .loading
        let result = getListsUseCase.execute()
        switch result {
        case .success(let data):
            self.lists = data
            self.state = .success
        case .failure(let error):
            print("❌ Error al cargar listas: \(error)")
            self.state = .error("Error al cargar las listas: \(error.localizedDescription)")
        }
    }

    func createList() {
        let name = newListName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }
        let result = createListUseCase.execute(with: name)
        if case .success = result {
            newListName = ""
            loadLists()
        }
    }

    func save(photoID: String, to list: PhotoList) {  
        print("✅ Foto \(photoID) guardada en lista \(list.name)")
        // Aquí más adelante implementarás la lógica real.
    }
}

