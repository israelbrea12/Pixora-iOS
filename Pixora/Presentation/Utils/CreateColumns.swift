//
//  CreateColumns.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 30/4/25.
//

import Foundation

func createColumns(from photos: [Photo], columnCount: Int) -> [[Photo]] {
    var columns: [[Photo]] = Array(repeating: [], count: columnCount)
    for (index, photo) in photos.enumerated() {
        columns[index % columnCount].append(photo)
    }
    return columns
}

