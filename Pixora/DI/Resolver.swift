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
    
    func resolve<T, Arg>(_ type: T.Type, argument: Arg) -> T {
        container.resolve(T.self, argument: argument)!
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
            APIManagerImpl(
                networkManager: resolver.resolve(NetworkManager.self)!
            )
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
        
        container.register(FavoritePhotoDataSource.self){ resolver in
            FavoritePhotoDataSourceImpl()
        }.inObjectScope(.container)
        
        container.register(PhotoListDataSource.self){ resolver in
            PhotoListDataSourceImpl()
        }.inObjectScope(.container)
        
        container.register(UserActivityDataSource.self){ resolver in
            UserActivityDataSourceImpl()
        }.inObjectScope(.container)
        
        container.register(MyPhotosDataSource.self){ resolver in
            MyPhotosDataSourceImpl()
        }.inObjectScope(.container)
    }
}

// MARK: - Repository

extension Resolver {
    @MainActor func injectRepository() {
        
        //--------------------------------------------------------------------------------
        // Photo
        container.register(PhotoRepository.self){resolver in
            PhotoRepositoryImpl(
                photoDataSource: resolver.resolve(
                    PhotoDataSource.self
                )!,
                favDataSource: resolver.resolve(FavoritePhotoDataSource.self)!,
                myPhotosDataSource: resolver.resolve(MyPhotosDataSource.self)!
            )
        }.inObjectScope(.container)
        
        container.register(PhotoListRepository.self){resolver in
            PhotoListRepositoryImpl(
                dataSource: resolver.resolve(PhotoListDataSource.self)!
            )
        }.inObjectScope(.container)
        
        container.register(UserActivityRepository.self){resolver in
            UserActivityRepositoryImpl(
                dataSource: resolver.resolve(UserActivityDataSource.self)!
            )
        }.inObjectScope(.container)
        
    }
}


// MARK: - UseCase

extension Resolver {
    @MainActor func injectUseCase() {
        
        //--------------------------------------------------------------------------------
        // Photo
        container.register(GetPhotosUseCase.self){resolver in
            GetPhotosUseCase(
                photoRepository: resolver.resolve(PhotoRepository.self)!
            )
        }.inObjectScope(.container)
        
        //--------------------------------------------------------------------------------
        // Favorite
        container.register(SetPhotoAsFavoriteUseCase.self){resolver in
            SetPhotoAsFavoriteUseCase(
                photoRepository: resolver.resolve(PhotoRepository.self)!
            )
        }.inObjectScope(.container)
        
        container.register(DeletePhotoAsFavoriteUseCase.self){resolver in
            DeletePhotoAsFavoriteUseCase(
                photoRepository: resolver.resolve(PhotoRepository.self)!
            )
        }.inObjectScope(.container)
        
        container.register(IsPhotoFavoriteUseCase.self){resolver in
            IsPhotoFavoriteUseCase(
                photoRepository: resolver.resolve(PhotoRepository.self)!
            )
        }.inObjectScope(.container)
        
        container.register(GetFavoritePhotosUseCase.self){resolver in
            GetFavoritePhotosUseCase(
                photoRepository: resolver.resolve(PhotoRepository.self)!
            )
        }.inObjectScope(.container)
        
        container.register(CreatePhotoListUseCase.self){resolver in
            CreatePhotoListUseCase(
                photoListRepository: resolver.resolve(PhotoListRepository.self)!
            )
        }.inObjectScope(.container)
        
        container.register(GetPhotoListsUseCase.self){resolver in
            GetPhotoListsUseCase(
                photoListRepository: resolver.resolve(PhotoListRepository.self)!
            )
        }.inObjectScope(.container)
        
        container.register(AddPhotoToListUseCase.self){resolver in
            AddPhotoToListUseCase(
                photoListRepository: resolver.resolve(PhotoListRepository.self)!
            )
        }.inObjectScope(.container)
        
        container.register(IsPhotoInAnyListUseCase.self){resolver in
            IsPhotoInAnyListUseCase(
                photoListRepository: resolver.resolve(PhotoListRepository.self)!
            )
        }.inObjectScope(.container)
        
        container.register(GetPhotosFromPhotoListUseCase.self){resolver in
            GetPhotosFromPhotoListUseCase(
                photoListRepository: resolver.resolve(PhotoListRepository.self)!
            )
        }.inObjectScope(.container)
        
        container.register(GetUserActivitiesUseCase.self){resolver in
            GetUserActivitiesUseCase(
                userActivityRepository: resolver.resolve(UserActivityRepository.self)!)
        }.inObjectScope(.container)
        
        container.register(SaveUserActivityUseCase.self){resolver in
            SaveUserActivityUseCase(
                userActivityRepository: resolver.resolve(UserActivityRepository.self)!)
        }.inObjectScope(.container)
        
        container.register(FetchMyPhotosUseCase.self){resolver in
            FetchMyPhotosUseCase(
                photoRepository: resolver.resolve(PhotoRepository.self)!)
        }.inObjectScope(.container)
        
        container.register(SaveMyPhotoUseCase.self){resolver in
            SaveMyPhotoUseCase(
                photoRepository: resolver.resolve(PhotoRepository.self)!)
        }.inObjectScope(.container)
    }

}


// MARK: - ViewModel

extension Resolver {
    @MainActor func injectViewModel() {
        
        //--------------------------------------------------------------------------------
        // Photo
        container.register(HomeViewModel.self){resolver in
            HomeViewModel(
                getPhotosUseCase: resolver.resolve(GetPhotosUseCase.self)!
            )
        }.inObjectScope(.container)
        
        container.register(SearchViewModel.self){resolver in
            SearchViewModel(
                getPhotosUseCase: resolver.resolve(GetPhotosUseCase.self)!
            )
        }.inObjectScope(.container)
        
        container.register(PhotoDetailsViewModel.self){resolver in
            PhotoDetailsViewModel(
                setPhotoAsFavoriteUseCase: resolver
                    .resolve(SetPhotoAsFavoriteUseCase.self)!,
                deletePhotoAsFavoriteUseCase: resolver
                    .resolve(DeletePhotoAsFavoriteUseCase.self)!,
                isPhotoFavoriteUseCase: resolver
                    .resolve(IsPhotoFavoriteUseCase.self)!,
                isPhotoInAnyListUseCase: resolver
                    .resolve(IsPhotoInAnyListUseCase.self)!,
                saveUserActivityUseCase: resolver.resolve(SaveUserActivityUseCase.self)!)
        }.inObjectScope(.container)
        
        container.register(FavsViewModel.self){resolver in
            FavsViewModel(
                getFavoritePhotosUseCase: resolver
                    .resolve(GetFavoritePhotosUseCase.self)!
            )
        }.inObjectScope(.container)
        
        container.register(NewListViewModel.self) { resolver in
            NewListViewModel(
                getListsUseCase: resolver.resolve(GetPhotoListsUseCase.self)!,
                createListUseCase: resolver
                    .resolve(CreatePhotoListUseCase.self)!,
                addPhotoToListUseCase: resolver
                    .resolve(AddPhotoToListUseCase.self)!,
                getPhotosFromListUseCase: resolver.resolve(GetPhotosFromPhotoListUseCase.self)!,
                saveUserActivityUseCase: resolver.resolve(SaveUserActivityUseCase.self)!
            )
        }.inObjectScope(.container)
        
        container.register(ListsViewModel.self) { resolver in
            ListsViewModel(
                getListsUseCase: resolver.resolve(GetPhotoListsUseCase.self)!,
                getPhotosFromListUseCase: resolver.resolve(GetPhotosFromPhotoListUseCase.self)!
            )
        }.inObjectScope(.container)
        
        container.register(PhotoListDetailViewModel.self) { resolver in
            PhotoListDetailViewModel(
                getPhotosFromListUseCase: resolver.resolve(GetPhotosFromPhotoListUseCase.self)!
            )
        }.inObjectScope(.container)
        
        container.register(NotificationsViewModel.self) { resolver in
            NotificationsViewModel(
                getUserActivitiesUseCase: resolver.resolve(GetUserActivitiesUseCase.self)!
            )
        }.inObjectScope(.container)
        
        container.register(MyPhotosViewModel.self) { resolver in
            MyPhotosViewModel(
                fetchMyPhotosUseCase: resolver.resolve(FetchMyPhotosUseCase.self)!
            )
        }.inObjectScope(.container)

        container.register(PhotoFormViewModel.self) { resolver in
            PhotoFormViewModel(
                saveMyPhotoUseCase: resolver.resolve(SaveMyPhotoUseCase.self)!
            )
        }.inObjectScope(.container)
        
        container.register(MainViewModel.self) { resolver in
            MainViewModel(
                
            )
        }.inObjectScope(.container)
    }
}
