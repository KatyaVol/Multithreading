//
//  MainViewModel.swift
//  architecture
//
//  Created by Ekaterina Volobueva on 07.05.2024.
//

import Foundation

struct MainViewModel {
    let joke: Joke?
    let posts: [Posts]?
    let imageData: Data?
    let networkError: NetworkError?
}
