//
//  Person.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 19.07.2021.
//

import Foundation

struct Person: Decodable {
    let id: Int
    let name: String
    let biography: String?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case biography
        case profilePath = "profile_path"
    }
}
