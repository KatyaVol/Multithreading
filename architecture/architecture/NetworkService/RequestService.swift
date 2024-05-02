//
//  RequestService.swift
//  architecture
//
//  Created by Ekaterina Volobueva on 25.04.2024.
//

import Foundation

protocol RequestServiceProtocol {
    func getJoke() -> URLRequest?
    func getPosts() -> URLRequest?
    func getImage() -> URLRequest?
}

final class RequestService: RequestServiceProtocol {
    
    private enum BaseUrls {
        static let baseJokeUrl = "https://api.chucknorris.io"
        static let jsonplaceholderUrl = "https://jsonplaceholder.typicode.com"
        static let imageUrl = "https://www.planetware.com"
    }
    
    private enum Path {
        static let jokePath = "/jokes/random"
        static let commentsPath = "/comments"
        static let imagePath = "/photos-large/F/france-paris-eiffel-tower.jpg"
    }
    
    func getJoke() -> URLRequest? {
        guard let url = URL(string: BaseUrls.baseJokeUrl + Path.jokePath) else { return nil }
        let request = URLRequest(url: url)
        return request
    }
    
    func getPosts() -> URLRequest? {
        guard let url = URL(string: BaseUrls.jsonplaceholderUrl + Path.commentsPath) else { return nil}
        let request = URLRequest(url: url)
        return request
    }
    
    func getImage() -> URLRequest? {
        guard let url = URL(string: BaseUrls.imageUrl + Path.imagePath) else { return nil}
        let request = URLRequest(url: url)
        return request
    }
}
