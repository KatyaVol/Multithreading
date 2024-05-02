//
//  Joke.swift
//  architecture
//
//  Created by Ekaterina Volobueva on 25.04.2024.
//

import Foundation

struct Joke: Decodable {
    let categories: [String]?
    let createdAt: String
    let iconURL: String
    let id, updatedAt: String
    let url: String
    let value: String

    enum CodingKeys: String, CodingKey {
        case categories, id, url, value
        case createdAt = "created_at"
        case iconURL = "icon_url"
        case updatedAt = "updated_at"
    }
}
