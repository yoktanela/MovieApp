//
//  Media.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 19.07.2021.
//

import Foundation

enum Media: Decodable {
    case movie(Movie)
    case person(Person)
    case others
    
    enum CodingKeys: String, CodingKey {
        case type = "media_type"
    }

    enum MediaType: String, Decodable {
        case movie, person
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            let type = try container.decode(MediaType.self, forKey: .type)
            let associatedContainer = try decoder.singleValueContainer()
            
            switch type {
            case .movie:
                let movie = try associatedContainer.decode(Movie.self)
                self = .movie(movie)
            case .person:
                let person = try associatedContainer.decode(Person.self)
                self = .person(person)
            }
        } catch {
            self = .others
        }
    }
    
    func get() -> Decodable? {
        switch self {
        case .movie(let movie):
            return movie
        case .person(let person):
            return person
        default:
            return nil
        }
    }
}
