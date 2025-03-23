//
//  RequestProtocol.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

protocol RequestProtocol {
    var host: String { get }
    var path: String { get }
    var httpMethodType: HTTPMethodType { get }
    var headers: [String:String] { get }
    var params: [String:Any] { get }
    var urlParams: [String:String?] { get }
    
    func request() throws -> URLRequest
}
