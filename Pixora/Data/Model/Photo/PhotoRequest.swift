//
//  PhotoRequest.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

struct PhotoRequest: RequestProtocol, CustomStringConvertible {
    
    private let page: Int
    private let query: String
    
    var path: String {
        DataConstant.photoSearchUrl
    }
    
    var httpMethodType: HTTPMethodType {
        .GET
    }
    
    var urlParams: [String: String?] {
        var params = ["page": "\(page)",
                      "per_page": "\(DataConstant.per_page)"]
        
        if !query.isEmpty {
            params["query"] = query
        }
        return params
    }
    
    init(page: Int, query: String) {
        self.page = page
        self.query = query
    }
}
