//
//  AppService.swift
//  architecture
//
//  Created by Ekaterina Volobueva on 25.04.2024.
//

import UIKit

protocol AppProviderProtocol {
    func fetchJoke(completion: @escaping (Result<Joke, NetworkError>) -> Void)
    func fetchPosts(completion: @escaping (Result<[Posts], NetworkError>) -> Void)
    func fetchImage(completion: @escaping (Result<Data, NetworkError>) -> Void)
}

final class AppProvider: AppProviderProtocol {
    
    // MARK: - Private Properties
    
    private let networkService: NetworkServiceProtocol
    private let requestService: RequestServiceProtocol
    
    // MARK: - Init
    
    init(networkService: NetworkServiceProtocol, requestService: RequestServiceProtocol) {
        self.networkService = networkService
        self.requestService = requestService
    }
    
    // MARK: - Methods
    
    func fetchJoke(completion: @escaping (Result<Joke, NetworkError>) -> Void) {
        guard let request = try? requestService.getData(host: .baseJokeUrl, path: .jokePath) else { return }
        networkService.fetchData(request: request, completion: completion)
    }
    
    func fetchPosts(completion: @escaping (Result<[Posts], NetworkError>) -> Void) {
        guard let request = try? requestService.getData(host: .jsonplaceholderUrl, path: .commentsPath) else { return }
        networkService.fetchData(request: request, completion: completion)
    }
    
    func fetchImage(completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let request = try? requestService.getData(host: .imageUrl, path: .imagePath) else { return }
        networkService.fetchImage(request: request, completion: completion)
    }
}
