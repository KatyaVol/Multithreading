//
//  MainViewPresenter.swift
//  architecture
//
//  Created by Ekaterina Volobueva on 25.04.2024.
//

import Foundation

protocol MainViewPresenterProtocol {
    func fetchButtonTapped()
}

final class MainViewPresenter: MainViewPresenterProtocol {
    
    weak var view: MainViewControllerProtocol!
    
    // MARK: - Private Properties
    
    private let appProvider: AppProviderProtocol
    
    // MARK: - Init
    
    init(appProvider: AppProviderProtocol) {
        self.appProvider = appProvider
    }
    
    //MARK: - Methods
    
    func fetchButtonTapped() {
        DispatchQueue.global().async { [weak self] in
            
            let group = DispatchGroup()
            var joke: Joke?
            var networkError: NetworkError?
            var posts: [Posts]?
            var imageData: Data?
            
            group.enter()
            self?.appProvider.fetchJoke { [weak self] result in
                guard self != nil else { return }
                switch result {
                case .success(let jokeModel):
                    joke = jokeModel
                case .failure(let error):
                    networkError = error
                }
                group.leave()
            }
            
            group.enter()
            self?.appProvider.fetchPosts { [weak self] result in
                guard self != nil else { return }
                switch result {
                case .success(let postsModel):
                    posts = postsModel
                case .failure(let error):
                    networkError = error
                }
                group.leave()
            }
            
            group.enter()
            self?.appProvider.fetchImage { [weak self] result in
                guard self != nil else { return }
                switch result {
                case .success(let data):
                    imageData = data
                case .failure(let error):
                    networkError = error
                }
                group.leave()
            }
            
            group.notify(queue: .main) {
                if let joke = joke {
                    self?.view.fetchJokeSucceeded(joke: joke)
                }
                
                if let posts = posts {
                    self?.view.fetchPostsSucceeded(posts: posts)
                }
                
                if let networkError = networkError {
                    self?.view.fetchFailed(error: networkError)
                }
                
                if let imageData = imageData {
                    self?.view.fetchImageSucceeded(image: imageData)
                }
                
                self?.view.stopActivityIndicator()
            }
        }
    }
}
