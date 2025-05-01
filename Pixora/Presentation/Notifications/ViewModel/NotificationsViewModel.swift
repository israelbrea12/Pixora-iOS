//
//  NotificationsViewModel.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

@MainActor
final class NotificationsViewModel: ObservableObject {
    
    // MARK: - Publisheds
    @Published var actions: [UserActivity] = []
    @Published var state: ViewState = .initial
    
    
    // MARK: - Use cases
    let getUserActivitiesUseCase: GetUserActivitiesUseCase

    
    // MARK: - Lifecycle functions
    init(getUserActivitiesUseCase: GetUserActivitiesUseCase) {
        self.getUserActivitiesUseCase = getUserActivitiesUseCase
    }

    
    // MARK: - Functions
    func loadActions() {
        switch getUserActivitiesUseCase.execute() {
        case .success(let actions):
            self.actions = actions
            self.state = actions.isEmpty ? .empty : .success
        case .failure(let error):
            self.state = .error(error.localizedDescription)
        }
    }
}
