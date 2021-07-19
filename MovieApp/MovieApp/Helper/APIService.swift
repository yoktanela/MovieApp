//
//  APIService.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 19.07.2021.
//

import Foundation
import Alamofire

public class APIService: NSObject {
    
    struct APIErrorResponse: Decodable {
        let errors: [String]
    }

    struct APIFailResponse: Decodable {
        var statusCode: Int
        var statusMessage: String
        var success: Bool
        
        enum CodingKeys: String, CodingKey {
            case statusCode = "status_code"
            case statusMessage = "status_message"
            case success
        }
    }
    
    override init() {
        super.init()
    }
    
    private func parseAPIResponse<T: Decodable> (response: AFDataResponse<Any>, completion: @escaping (_ success: Bool, _ message: String?, _ data: T?) -> Void) {
        switch response.result {
        case .success:
            guard let data = response.data else {
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                let object = try jsonDecoder.decode(T.self, from: data)
                completion(true, nil, object)
            } catch {
                do {
                    let result = try jsonDecoder.decode(APIErrorResponse.self, from: data)
                    if result.errors.count > 0 {
                        completion(false, result.errors[0], nil)
                    } else {
                        //TODO: Localize error message
                        completion(false, "unknown error", nil)
                    }
                } catch {
                    do {
                        let failResult = try jsonDecoder.decode(APIFailResponse.self, from: data)
                        completion(false, failResult.statusMessage, nil)
                    } catch {
                        //TODO: Localize error message
                        completion(false, "unknown error", nil)
                    }
                }
            }
        case .failure(let error):
            completion(false, error.errorDescription, nil)
        }
    }
    
    func getPopularMovies(page: Int = 1, completion: @escaping (_ success: Bool, _ message: String?, _ movieList: [Movie]?) -> Void) {
        AF.request(Router.getPopularMovies(page: page, language: Locale.preferredLanguages[0])).responseJSON { (response) in
            self.parseAPIResponse(response: response) { (success, message, moviesResponse: MoviesResponse?) in
                completion(success, message, moviesResponse?.results)
            }
        }
    }
    
    func getPerson(id: Int, completion: @escaping (_ success: Bool, _ message: String?, _ movieList: Person?) -> Void) {
        AF.request(Router.getPerson(id: id, language: Locale.preferredLanguages[0])).responseJSON { (response) in
            self.parseAPIResponse(response: response) { (success, message, person: Person?) in
                completion(success, message, person)
            }
        }
    }
    
    func getSearchResults(searchText: String, completion: @escaping (_ success: Bool, _ message: String?, _ movieList: [Movie]?, _ personList: [Person]?) -> Void) {
        AF.request(Router.getSearchResults(searchText: searchText, language: Locale.preferredLanguages[0])).responseJSON { (response) in
            self.parseAPIResponse(response: response) { (success, message, mediaResponse: MediaResponse?) in
                var movies: [Movie]?
                var persons: [Person]?
                
                mediaResponse?.results.forEach({ media in
                    switch media {
                    case .movie:
                        if let movie = media.get() as? Movie {
                            if movies == nil {
                                movies = []
                            }
                            movies?.append(movie)
                        }
                    case .person:
                        if let person = media.get() as? Person {
                            if persons == nil {
                                persons = []
                            }
                            persons?.append(person)
                        }
                    default:
                        break
                    }
                })
                completion(success, message, movies, persons)
            }
        }
    }
    
    func getCast(id: Int, completion: @escaping (_ success: Bool, _ message: String?, _ cast: Cast?) -> Void) {
        AF.request(Router.getCast(id: id, language: Locale.preferredLanguages[0])).responseJSON { (response) in
            self.parseAPIResponse(response: response) { (success, message, cast: Cast?) in
                completion(success, message, cast)
            }
        }
    }
    
    func getVideos(id: Int, completion: @escaping (_ success: Bool, _ message: String?, _ cast: VideoResult?) -> Void) {
        AF.request(Router.getVideos(id: id, language: Locale.preferredLanguages[0])).responseJSON { (response) in
            self.parseAPIResponse(response: response) { (success, message, videos: VideoResult?) in
                completion(success, message, videos)
            }
        }
    }
    
    func getMovieCredits(id: Int, completion: @escaping (_ success: Bool, _ message: String?, _ movieList: MovieCreditResponse?) -> Void) {
        AF.request(Router.getMovieCredits(id: id, language: Locale.preferredLanguages[0])).responseJSON { (response) in
            self.parseAPIResponse(response: response) { (success, message, movieList: MovieCreditResponse?) in
                completion(success, message, movieList)
            }
        }
    }
}
