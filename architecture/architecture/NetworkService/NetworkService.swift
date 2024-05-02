//
//  NetworkService.swift
//  architecture
//
//  Created by Ekaterina Volobueva on 25.04.2024.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchData<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void)
    func fetchImage(request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) 
}

final class NetworkService: NetworkServiceProtocol {
    func fetchData<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                completion(.failure(.badRequest))
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200...299:
                    if let data = data {
                        do {
                            let value = try JSONDecoder().decode(T.self, from: data)
                            completion(.success(value))
                        } catch {
                            completion(.failure(.decodeError))
                        }
                    }
                    
                case 400...499:
                    completion(.failure(.unAuthorized))
                    
                case 500...599:
                    completion(.failure(.serverError))
                    
                default:
                    completion(.failure(.unknown))
                    assertionFailure()
                }
            }
        }
        dataTask.resume()
    }
    
    func fetchImage(request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                completion(.failure(.badRequest))
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200...299:
                    if let data = data {
                        completion(.success(data))
                    }
                    
                case 400...499:
                    completion(.failure(.unAuthorized))
                    
                case 500...599:
                    completion(.failure(.serverError))
                    
                default:
                    completion(.failure(.unknown))
                    assertionFailure()
                }
            }
        }
        dataTask.resume()
    }
}
