//
//  NotificationsViewModel.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

@MainActor
final class NotificationsViewModel: ObservableObject {
    @Published var actions: [UserActivity] = []
    @Published var state: ViewState = .initial
    
    let getUserActivitiesUseCase: GetUserActivitiesUseCase

    init(getUserActivitiesUseCase: GetUserActivitiesUseCase) {
        self.getUserActivitiesUseCase = getUserActivitiesUseCase
    }

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
