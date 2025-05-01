//
//  NetworkExtensions.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation
import CommonCrypto
import CryptoSwift

extension RequestProtocol {
    
    var host: String {
        DataConstant.baseUrl
    }
    
    var headers: [String : String] {
        [:]
    }

    
    var params: [String : Any] {
        [:]
    }
    
    var urlParams: [String : String?] {
        [:]
    }
    
    func request() throws -> URLRequest {
        var urlComponents = URLComponents(string: host)!
        urlComponents.scheme = DataConstant.scheme
        urlComponents.host = host
        urlComponents.port = DataConstant.port
        urlComponents.path = path
        
        let ts = String(Date().timeIntervalSince1970)
        let hash = "\(ts)\(DataConstant.privateKey)\(DataConstant.publicKey)".md5()
        
        var queryParamList: [URLQueryItem] = [
            URLQueryItem(name: DataConstant.apiKey, value: DataConstant.publicKey),
            URLQueryItem(name: DataConstant.ts, value: ts),
            URLQueryItem(name: DataConstant.hash, value: hash),
            URLQueryItem(name: "orientation", value: "portrait")
        ]
        
        if !urlParams.isEmpty {
            queryParamList.append(contentsOf: urlParams.map{ URLQueryItem(name: $0, value: $1)})
        }
        
        urlComponents.queryItems = queryParamList
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidUrl
        }
        
        print("Generated URL: \(url)")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethodType.rawValue
        
        if !headers.isEmpty {
            urlRequest.allHTTPHeaderFields = headers
        }
        
        
        if !params.isEmpty {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params)
        }
        
        //urlRequest.setValue(DataConstant.applicationJson, forHTTPHeaderField: DataConstant.applicationJson)
        
        return urlRequest
    }
}

extension Error {
    func toAppError() -> AppError {
        if self is NetworkError {
            return .networkError("errorFetchingData")
        }
        return .unknownError("unknownError")
    }
}
