//
//  NetworkError.swift
//  architecture
//
//  Created by Ekaterina Volobueva on 30.04.2024.
//

import Foundation

enum NetworkError: Error {
    case badRequest
    case unAuthorized
    case notFound
    case serverError
    case decodeError
    case unknown
}
