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
    
    // Generic function to parse api response
    private func parseAPIResponse<T: Decodable> (response: AFDataResponse<Any>, completion: @escaping (_ success: Bool, _ message: String?, _ data: T?) -> Void) {
        switch response.result {
        case .success:
            guard let data = response.data else {
                return
            }
            
            let jsonDecoder = JSONDecoder()
            do {
                // Decode api result using given class type
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
    
    /** Used to get popular movies via using Movie Database API
    - Parameters:
        - page: Specify which page to query.
        - completion: Invoked when request failed or completed.
        - success: Boolean value that returns true if list of desired movie could be reached.
        - message: A string value that returns error message if any error occurs.
        - movieList: List of ‘Movie’ objects.
     */
    func getPopularMovies(page: Int = 1, completion: @escaping (_ success: Bool, _ message: String?, _ movieList: [Movie]?) -> Void) {
        AF.request(Router.getPopularMovies(page: page, language: Locale.preferredLanguages[0])).responseJSON { (response) in
            self.parseAPIResponse(response: response) { (success, message, moviesResponse: MoviesResponse?) in
                completion(success, message, moviesResponse?.results)
            }
        }
    }
    
    func getMovie(id: Int, completion: @escaping (_ success: Bool, _ message: String?, _ movie: Movie?) -> Void) {
        AF.request(Router.getMovie(id: id, language: Locale.preferredLanguages[0])).responseJSON { (response) in
            self.parseAPIResponse(response: response) { (success, message, movie: Movie?) in
                completion(success, message, movie)
            }
        }
    }
    
    /** Used to get person by id via using Movie Database API
    - Parameters:
        - id: Unique identifier for person.
        - completion: Invoked when request failed or completed.
        - success: Boolean value that returns true if desired person could be reached.
        - message: A string value that returns error message if any error occurs.
        - person: Person object that meets requested features.
     */
    func getPerson(id: Int, completion: @escaping (_ success: Bool, _ message: String?, _ person: Person?) -> Void) {
        AF.request(Router.getPerson(id: id, language: Locale.preferredLanguages[0])).responseJSON { (response) in
            self.parseAPIResponse(response: response) { (success, message, person: Person?) in
                completion(success, message, person)
            }
        }
    }
    
    /** Used to search multiple models in a single request.
    - Parameters:
        - searchText: Pass a text query to search.
        - completion: Invoked when request failed or completed.
        - success: Boolean value that returns true if api response is successful
        - message: A string value that returns error message if any error occurs.
        - movieList: List of ‘Movie’ objects.
        - personList: List of ‘Person’ objects.
     */
    func getSearchResults(searchText: String, completion: @escaping (_ success: Bool, _ message: String?, _ movieList: [Movie]?, _ personList: [Person]?) -> Void) {
        AF.request(Router.getSearchResults(searchText: searchText, language: Locale.preferredLanguages[0])).responseJSON { (response) in
            self.parseAPIResponse(response: response) { (success, message, mediaResponse: MediaResponse?) in
                var movies: [Movie]?
                var persons: [Person]?
                
                // Filter movies and persons from the media list that contains both media types.
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
    
    /** Used to get the cast for a movie.
    - Parameters:
        - id: Unique identifier for movie.
        - completion: Invoked when request failed or completed.
        - success: Boolean value that returns true if api response is successful.
        - message: A string value that returns error message if any error occurs.
        - cast: 'Cast' object that contains all cast memebers of movie
     */
    func getCast(id: Int, completion: @escaping (_ success: Bool, _ message: String?, _ cast: Cast?) -> Void) {
        AF.request(Router.getCast(id: id, language: Locale.preferredLanguages[0])).responseJSON { (response) in
            self.parseAPIResponse(response: response) { (success, message, cast: Cast?) in
                completion(success, message, cast)
            }
        }
    }
    
    /** Used to get available videos for a movie.
    - Parameters:
        - id: Unique identifier for movie.
        - completion: Invoked when request failed or completed.
        - success: Boolean value that returns true if api response is successful.
        - message: A string value that returns error message if any error occurs.
        - videoResult: 'VideoResult' object that contains all available videos for movie.
     */
    func getVideos(id: Int, completion: @escaping (_ success: Bool, _ message: String?, _ videoResult: VideoResult?) -> Void) {
        AF.request(Router.getVideos(id: id, language: Locale.preferredLanguages[0])).responseJSON { (response) in
            self.parseAPIResponse(response: response) { (success, message, videos: VideoResult?) in
                completion(success, message, videos)
            }
        }
    }
    
    /** Used to get the movie credits for a person.
    - Parameters:
        - id: Unique identifier for person.
        - completion: Invoked when request failed or completed.
        - success: Boolean value that returns true if api response is successful.
        - message: A string value that returns error message if any error occurs.
        - movieCreditResponse: 'MovieCreditResponse' object that contains movies that person take role.
     */
    func getMovieCredits(id: Int, completion: @escaping (_ success: Bool, _ message: String?, _ movieCreditResponse: MovieCreditResponse?) -> Void) {
        AF.request(Router.getMovieCredits(id: id, language: Locale.preferredLanguages[0])).responseJSON { (response) in
            self.parseAPIResponse(response: response) { (success, message, movieCreditResponse: MovieCreditResponse?) in
                completion(success, message, movieCreditResponse)
            }
        }
    }
    
    /** Used to get the list of official genres for movies.
    - Parameters:
        - completion: Invoked when request failed or completed.
        - success: Boolean value that returns true if api response is successful.
        - message: A string value that returns error message if any error occurs.
        - genres: 'Genres' object that contains all genres for movies.
     */
    func getGenres(completion: @escaping (_ success: Bool, _ message: String?, _ genres: Genres?) -> Void) {
        AF.request(Router.getGenres(language: Locale.preferredLanguages[0])).responseJSON { (response) in
            self.parseAPIResponse(response: response) { (success, message, genres: Genres?) in
                completion(success, message, genres)
            }
        }
    }
}
