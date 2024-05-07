//
//  RequestService.swift
//  architecture
//
//  Created by Ekaterina Volobueva on 25.04.2024.
//

import Foundation

enum BaseUrls: String {
    case baseJokeUrl = "https://api.chucknorris.io"
    case jsonplaceholderUrl = "https://jsonplaceholder.typicode.com"
    case imageUrl = "https://www.planetware.com"
}

enum Path: String {
    case jokePath = "/jokes/random"
    case commentsPath = "/comments"
    case imagePath = "/photos-large/F/france-paris-eiffel-tower.jpg"
}

protocol RequestServiceProtocol {
    func getData(host: BaseUrls, path: Path) throws -> URLRequest
}

final class RequestService: RequestServiceProtocol {
    
    func getData(host: BaseUrls, path: Path) throws -> URLRequest {
        guard let url = URL(string: host.rawValue + path.rawValue) else {
            throw NetworkError.badRequest
        }
        let request = URLRequest(url: url)
        return request
    }
}
