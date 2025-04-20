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
    private let photo: Photo
    private let addPhotoToListUseCase: AddPhotoToListUseCase

    init(
        getListsUseCase: GetPhotoListsUseCase,
        createListUseCase: CreatePhotoListUseCase,
        addPhotoToListUseCase: AddPhotoToListUseCase,
        photo: Photo
    ) {
        self.getListsUseCase = getListsUseCase
        self.createListUseCase = createListUseCase
        self.addPhotoToListUseCase = addPhotoToListUseCase
        self.photo = photo
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
    
    func addPhotoToList(_ list: PhotoList) {
        let result = addPhotoToListUseCase.execute(photo: photo, list: list)
        switch result {
        case .success:
            print("✅ Foto añadida a la lista \(list.name)")
        case .failure(let error):
            print("❌ Error al añadir foto: \(error.localizedDescription)")
        }
    }
}

