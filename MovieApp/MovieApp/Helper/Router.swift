//
//  Router.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 19.07.2021.
//

import Foundation
import Alamofire

internal enum Router: URLRequestConvertible {
    static let baseURLString = Constants.movieDBApiBaseURL
    
    case getPopularMovies(page: Int, language: String)
    case getPerson(id: Int, language: String)
    case getSearchResults(searchText: String, language: String)
    
    func asURLRequest() throws -> URLRequest {
        var method: HTTPMethod {
            switch self {
            case .getPopularMovies, .getPerson, .getSearchResults:
                return .get
            }
        }
        
        let params: ([String: Any]?) = {
            switch self {
            case .getPopularMovies, .getPerson, .getSearchResults:
                return nil
            }
        }()
        
        let url: URL = {
            let relativePath: String?
            var query: String = ""
            switch self {
            case .getPopularMovies(let page, let language):
                relativePath = "movie/popular"
                query = "?page=\(page)&language=\(language)"
            case .getPerson(let id, let language):
                relativePath = "person"
                query = "/\(id)?language=\(language)"
            case .getSearchResults(let searchText, let language):
                relativePath = "search/multi"
                query = "?language=\(language)&query=\(searchText)"
            }
            
            var url = URL(string: Router.baseURLString)!
            if let relativePath = relativePath {
                url.appendPathComponent(relativePath)
                query += "&api_key=\(Constants.apiKey)"
                url = URL(string: url.absoluteString + query)!
            }
            
            return url
        }()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        let encoding = JSONEncoding.default
        return try encoding.encode(urlRequest, with: params)
    }
}
