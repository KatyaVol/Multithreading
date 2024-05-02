//
//  AppService.swift
//  architecture
//
//  Created by Ekaterina Volobueva on 25.04.2024.
//

import UIKit

protocol AppServiceProtocol {
    func fetchJoke(completion: @escaping (Result<Joke, NetworkError>) -> Void)
    func fetchPosts(completion: @escaping (Result<[Posts], NetworkError>) -> Void)
    func fetchImage(completion: @escaping (Result<Data, NetworkError>) -> Void)
}

final class AppService: AppServiceProtocol {
    
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
        guard let request = requestService.getJoke() else { return }
        networkService.fetchData(request: request, completion: completion)
    }
    
    func fetchPosts(completion: @escaping (Result<[Posts], NetworkError>) -> Void) {
        guard let request = requestService.getPosts() else { return }
        networkService.fetchData(request: request, completion: completion)
    }
    
    func fetchImage(completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let request = requestService.getImage() else { return }
        networkService.fetchImage(request: request, completion: completion)
    }
}
