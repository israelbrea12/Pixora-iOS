//
//  DataConstants.swift
//  Pixora
//
//  Created by Israel Brea Piñero on 23/3/25.
//

import Foundation

public enum DataConstant {
    public static let baseUrl: String = "api.unsplash.com"
    public static let port: Int = 443
    public static let photoListUrl: String = "/photos"
    public static let photoSearchUrl: String = "/search/photos"
    public static let scheme: String = "https"
    public static let per_page = 20
    
    public static let apiKey: String = "client_id"
    public static let apiKeyValue: String = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0Nzc1NmRhZjkwODMwYTdhMDNkNjA1N2JjYzJmNDBmNiIsIm5iZiI6MTczNDYwNDU5MS41MjksInN1YiI6IjY3NjNmNzJmMWY0YTk1NzJjNGZmZmUxYyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.GoXNV7khGYathGErrG11xGrBjz8SyYhid7ioYnCaQPc"
    public static let ts: String = "ts"
    public static let hash: String = "hash"
    public static let contentType: String = "Content-Type"
    public static let applicationJson: String = "application/json"

    public static let privateKey: String = "c54ac7101319572d23313a3b8f26df33fdc90549"
    public static let publicKey: String = "d17cbcf918881825e0de87aa7ff37844"
}
