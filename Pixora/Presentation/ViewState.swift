//
//  ViewState.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

enum ViewState: Equatable {
    case initial, loading, error(String), success, empty
}
