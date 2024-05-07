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
            let myQueue = DispatchQueue.global()
            
            var joke: Joke?
            var networkError: NetworkError?
            var posts: [Posts]?
            var imageData: Data?
            
            let fetchJokeWorkItem = DispatchWorkItem {
                group.enter()
                self?.appProvider.fetchJoke { [weak self] result in
                    defer { group.leave() }
                    guard let self = self else { return }
                    switch result {
                    case .success(let jokeModel):
                        joke = jokeModel
                    case .failure(let error):
                        networkError = error
                    }
                }
            }
            
            let fetchPostsWorkItem = DispatchWorkItem {
                group.enter()
                self?.appProvider.fetchPosts { [weak self] result in
                    defer { group.leave() }
                    guard let self = self else { return }
                    switch result {
                    case .success(let postsModel):
                        posts = postsModel
                    case .failure(let error):
                        networkError = error
                    }
                }
            }
            
            let fetchImageWorkItem = DispatchWorkItem {
                group.enter()
                self?.appProvider.fetchImage { [weak self] result in
                    defer { group.leave() }
                    guard let self = self else { return }
                    switch result {
                    case .success(let data):
                        imageData = data
                    case .failure(let error):
                        networkError = error
                    }
                }
            }
            
            myQueue.async(group: group, execute: fetchJokeWorkItem)
            myQueue.async(group: group, execute: fetchPostsWorkItem)
            myQueue.async(group: group, execute: fetchImageWorkItem)
            
            group.notify(queue: DispatchQueue.main) {
                DispatchQueue.main.async { [weak self] in
                    let viewModel = MainViewModel(joke: joke, 
                                                  posts: posts,
                                                  imageData: imageData,
                                                  networkError: networkError)
                    self?.view.updateView(with: viewModel)
                }
            }
        }
    }
}
