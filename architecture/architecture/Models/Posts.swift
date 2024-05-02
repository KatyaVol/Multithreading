//
//  Comment.swift
//  architecture
//
//  Created by Ekaterina Volobueva on 25.04.2024.
//

import Foundation

struct Posts: Decodable {
    let postId: Int
    let id: Int
    let name: String
    let email: String
    let body: String
}

