//
//  Cast.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 20.07.2021.
//

import Foundation

struct Cast: Decodable {
    let id: Int
    let cast: [CastMember]
}

struct CastMember: Decodable {
    let id: Int
    let name: String?
    let character: String?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case character
        case profilePath = "profile_path"
    }
}
