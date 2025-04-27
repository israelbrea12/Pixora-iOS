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
    @Published var listsWithPhotos: [(PhotoList, [Photo])] = []

    private let getListsUseCase: GetPhotoListsUseCase
    private let createListUseCase: CreatePhotoListUseCase
    private let addPhotoToListUseCase: AddPhotoToListUseCase
    private let getPhotosFromListUseCase: GetPhotosFromPhotoListUseCase
    private let saveUserActivityUseCase: SaveUserActivityUseCase

    init(
        getListsUseCase: GetPhotoListsUseCase,
        createListUseCase: CreatePhotoListUseCase,
        addPhotoToListUseCase: AddPhotoToListUseCase,
        getPhotosFromListUseCase: GetPhotosFromPhotoListUseCase,
        saveUserActivityUseCase: SaveUserActivityUseCase
    ) {
        self.getListsUseCase = getListsUseCase
        self.createListUseCase = createListUseCase
        self.addPhotoToListUseCase = addPhotoToListUseCase
        self.getPhotosFromListUseCase = getPhotosFromListUseCase
        self.saveUserActivityUseCase = saveUserActivityUseCase
    }

    func loadLists() {
        state = .loading
        switch getListsUseCase.execute() {
        case .success(let lists):
            Task {
                var result: [(PhotoList, [Photo])] = []

                await withTaskGroup(of: (PhotoList, [Photo]?).self) { group in
                    for list in lists {
                        group.addTask { [self] in
                            let photos = try? await getPhotosFromListUseCase.execute(for: list).get()
                            return (list, photos ?? [])
                        }
                    }

                    for await (list, photos) in group {
                        result.append((list, photos ?? []))
                    }
                }

                self.listsWithPhotos = result
                self.state = .success
            }
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
    
    func addPhoto(_ photo: Photo, to list: PhotoList) {
        let result = addPhotoToListUseCase.execute(photo: photo, list: list)
        switch result {
        case .success:
            print("✅ Foto añadida a la lista \(list.name)")
            
            let activity = UserActivity(
                id: UUID(),
                type: .addedToList,
                photo: photo,
                listName: list.name,
                timestamp: Date()
            )
            _ = saveUserActivityUseCase.execute(activity)

        case .failure(let error):
            print("❌ Error al añadir foto: \(error.localizedDescription)")
        }
    }
}
