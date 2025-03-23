//
//  NetworkExtensions.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

import FirebaseAuth
import FirebaseFirestore
import Foundation

extension RequestProtocol {
    
    var host: String {
        DataConstant.baseUrl
    }
    
    var headers: [String: String] {
        [
            "Authorization": "Bearer \(DataConstant.apiKeyValue)",
            "Content-Type": "application/json"
        ]
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
        urlComponents.path = path
        
        
        var queryParamList: [URLQueryItem] = [
        ]
        
        if !urlParams.isEmpty {
            queryParamList.append(contentsOf: urlParams.map{ URLQueryItem(name: $0, value: $1)})
        }
        
        urlComponents.queryItems = queryParamList
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidUrl
        }
        
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
        if let authError = self as? AuthErrorCode {
            switch authError.code {
            case .networkError:
                return .networkError("Error de conexión. Verifica tu internet.")
            case .wrongPassword:
                return .authenticationError("Contraseña incorrecta.")
            case .userNotFound:
                return .authenticationError("Usuario no encontrado.")
            case .emailAlreadyInUse:
                return .authenticationError("El correo ya está en uso.")
            case .weakPassword:
                return .authenticationError("La contraseña es demasiado débil.")
            default:
                return .authenticationError("Error de autenticación.")
            }
        }

        let nsError = self as NSError
        if nsError.domain == FirestoreErrorDomain {
            return .databaseError("Error en la base de datos: \(nsError.localizedDescription)")
        }

        return .unknownError(self.localizedDescription)
    }
}
