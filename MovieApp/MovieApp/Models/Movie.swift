//
//  Movie.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 19.07.2021.
//

import Foundation

// MARK: - Movie
struct Movie: Decodable {
    let id: Int
    let originalTitle, overview, posterPath: String
    let voteAverage: Double
    let releaseDate: String?
    let backdropPath: String?
    let genreIds: [Int]

    enum CodingKeys: String, CodingKey {
        case id
        case originalTitle = "original_title"
        case voteAverage = "vote_average"
        case overview = "overview"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
    }
}
