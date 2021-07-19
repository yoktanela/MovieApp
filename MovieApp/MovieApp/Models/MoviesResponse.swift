//
//  MoviesResponse.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 19.07.2021.
//

import Foundation

struct MoviesResponse: Decodable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
