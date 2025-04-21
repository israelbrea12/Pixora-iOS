//
//  ProfileViewModel.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var state: ViewState = .initial
    @Published var listsWithPhotos: [(PhotoList, [Photo])] = []

    private let getListsUseCase: GetPhotoListsUseCase
    private let getPhotosFromListUseCase: GetPhotosFromPhotoListUseCase

    init(
        getListsUseCase: GetPhotoListsUseCase,
        getPhotosFromListUseCase: GetPhotosFromPhotoListUseCase
    ) {
        self.getListsUseCase = getListsUseCase
        self.getPhotosFromListUseCase = getPhotosFromListUseCase
    }

    func loadLists() async {
        self.state = .loading

        switch getListsUseCase.execute() {
        case .success(let lists):
            var result: [(PhotoList, [Photo])] = []

            await withTaskGroup(of: (PhotoList, [Photo]?).self) { group in
                for list in lists {
                    group.addTask {
                        let photos = try? await self.getPhotosFromListUseCase.execute(for: list).get()
                        return (list, photos)
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

