//
//  ListsViewModel.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 22/4/25.
//

import Foundation

@MainActor
final class ListsViewModel: ObservableObject {
    
    // MARK: - Publisheds
    @Published var state: ViewState = .initial
    @Published var listsWithPhotos: [(PhotoList, [Photo])] = []

    
    // MARK: - Private vars
    private var hasLoaded = false

    
    // MARK: - Use cases
    private let getListsUseCase: GetPhotoListsUseCase
    private let getPhotosFromListUseCase: GetPhotosFromPhotoListUseCase

    
    // MARK: - Lifecycle functions
    init(
        getListsUseCase: GetPhotoListsUseCase,
        getPhotosFromListUseCase: GetPhotosFromPhotoListUseCase
    ) {
        self.getListsUseCase = getListsUseCase
        self.getPhotosFromListUseCase = getPhotosFromListUseCase
    }

    
    // MARK: - Functions
    func loadListsIfNeeded() async {
        guard !hasLoaded else { return }
        hasLoaded = true
        await loadLists()
    }

    func loadLists() async {
        self.state = .loading

        switch getListsUseCase.execute() {
        case .success(let lists):
            var result: [(PhotoList, [Photo])] = []

            await withTaskGroup(of: (PhotoList, [Photo]?).self) { group in
                for list in lists {
                    group.addTask {
                        do {
                            let photos = try await self.getPhotosFromListUseCase.execute(for: list).get()
                            return (list, photos)
                        } catch {
                            print(
                                "Error fetching photos for list \(list.name): \(error)"
                            )
                            return (list, nil)
                        }
                    }
                }

                for await (list, photos) in group {
                    if let photos = photos {
                        result.append((list, photos))
                    }
                }
            }

            if result.isEmpty {
                self.state = .empty
            } else {
                self.listsWithPhotos = result
                self.state = .success
            }

        case .failure(let error):
            self.state = .error(error.localizedDescription)
        }
    }
}
