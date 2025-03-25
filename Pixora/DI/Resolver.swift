//
//  Resolver.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

import Foundation
import Swinject

public final class Resolver {
    static let shared = Resolver()
    
    private var container = Container()
    
    private init() {
    }
    
    @MainActor func injectDependencies() {
        injectNetwork()
        injectDataSource()
        injectRepository()
        injectUseCase()
        injectViewModel()
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        container.resolve(T.self)!
    }
}

// MARK: - Network

extension Resolver {
    @MainActor func injectNetwork() {
        container.register(NetworkManager.self) { _ in
            NetworkManagerImpl()
        }.inObjectScope(.container)
        
        container.register(DataParser.self){_ in
            JsonDataParser()
        }.inObjectScope(.container)
        
        container.register(APIManager.self){ resolver in
            APIManagerImpl(networkManager: resolver.resolve(NetworkManager.self)!)
        }.inObjectScope(.container)
    }
}

// MARK: - DataSource
extension Resolver {
    @MainActor func injectDataSource() {
    
        //--------------------------------------------------------------------------------
        // Photo
        container.register(PhotoDataSource.self){ resolver in
            PhotoDataSourceImpl(apiManager: resolver.resolve(APIManager.self)!)
        }.inObjectScope(.container)
    }
}

// MARK: - Repository

extension Resolver {
    @MainActor func injectRepository() {
        
        //--------------------------------------------------------------------------------
        // Photo
        container.register(PhotoRepository.self){resolver in
            PhotoRepositoryImpl(photoDataSource: resolver.resolve(PhotoDataSource.self)!)
        }.inObjectScope(.container)
    }
}


// MARK: - UseCase

extension Resolver {
    @MainActor func injectUseCase() {
        
        //--------------------------------------------------------------------------------
        // Photo
        container.register(GetPhotosUseCase.self){resolver in
            GetPhotosUseCase(photoRepository: resolver.resolve(PhotoRepository.self)!)
        }.inObjectScope(.container)
    }

}


// MARK: - ViewModel

extension Resolver {
    @MainActor func injectViewModel() {
        
        //--------------------------------------------------------------------------------
        // Photo
        container.register(HomeViewModel.self){resolver in
            HomeViewModel(getPhotosUseCase: resolver.resolve(GetPhotosUseCase.self)!)
        }.inObjectScope(.container)
        
        container.register(SearchViewModel.self){resolver in
            SearchViewModel(getPhotosUseCase: resolver.resolve(GetPhotosUseCase.self)!)
        }.inObjectScope(.container)
    }
}
