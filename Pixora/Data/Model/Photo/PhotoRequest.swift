//
//  PhotoRequest.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

struct PhotoRequest: RequestProtocol, CustomStringConvertible {
    
    private let page: Int
    
    var path: String {
        DataConstant.photoListUrl
    }
    
    var httpMethodType: HTTPMethodType {
        .GET
    }
    
    var urlParams: [String: String?] {
        var params = [
            "page": "\(page)",
        ]
        return params
    }
    
    init(page: Int) {
        self.page = page
    }
}
