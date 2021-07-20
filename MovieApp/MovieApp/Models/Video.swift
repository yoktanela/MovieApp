//
//  Video.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 20.07.2021.
//

import Foundation

struct VideoResult: Decodable {
    let id: Int
    let results: [Video]
}

struct Video: Decodable {
    let id: String
    let key, name, site, type: String?
}
