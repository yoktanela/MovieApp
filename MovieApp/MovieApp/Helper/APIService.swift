//
//  APIService.swift
//  MovieApp
//
//  Created by Elanur Yoktan on 19.07.2021.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

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
    
    private func buildRequest(urlRequest: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)> {
        // TODO: Use response to determine the unsuccessful cases
        return URLSession.shared.rx.response(request: urlRequest)
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
    func getPopularMovies(page: Int = 1) -> Observable<[Movie]> {
        guard let urlRequest = Router.getPopularMovies(page: page, language: Locale.preferredLanguages[0]).urlRequest else {
            return Observable<[Movie]>.empty()
        }
        
        return buildRequest(urlRequest: urlRequest).map { _, data in
            try JSONDecoder().decode(MoviesResponse.self, from: data).results
        }
    }
    
    func getMovie(id: Int) -> Observable<Movie> {
        guard let urlRequest = Router.getMovie(id: id, language: Locale.preferredLanguages[0]).urlRequest else {
            return Observable<Movie>.empty()
        }
        
        return buildRequest(urlRequest: urlRequest).map { _, data in
            try JSONDecoder().decode(Movie.self, from: data)
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
    func getPerson(id: Int) -> Observable<Person> {
        guard let urlRequest = Router.getPerson(id: id, language: Locale.preferredLanguages[0]).urlRequest else {
            return Observable<Person>.empty()
        }
        
        return buildRequest(urlRequest: urlRequest).map { _, data in
            try JSONDecoder().decode(Person.self, from: data)
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
    func getSearchResults(searchText: String) -> Observable<(movies: [Movie], persons: [Person])> {
        
        guard let urlRequest = Router.getSearchResults(searchText: searchText, language: Locale.preferredLanguages[0]).urlRequest else {
            return Observable<(movies: [Movie], persons: [Person])>.empty()
        }
        
        return buildRequest(urlRequest: urlRequest).map { result, data in
            var movies: [Movie] = []
            var persons: [Person] = []
            try JSONDecoder().decode(MediaResponse.self, from: data).results.map({ media in
                switch media {
                case .movie:
                    if let movie = media.get() as? Movie {
                        movies.append(movie)
                    }
                case .person:
                    if let person = media.get() as? Person {
                        persons.append(person)
                    }
                default:
                    break
                }
            })
            return (movies: movies, persons: persons)
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
    func getCast(id: Int) -> Observable<Cast> {
        guard let urlRequest = Router.getCast(id: id, language: Locale.preferredLanguages[0]).urlRequest else {
            return Observable<Cast>.empty()
        }
        
        return buildRequest(urlRequest: urlRequest).map { _, data in
            try JSONDecoder().decode(Cast.self, from: data)
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
    func getVideos(id: Int) -> Observable<VideoResult> {
        guard let urlRequest = Router.getVideos(id: id, language: Locale.preferredLanguages[0]).urlRequest else {
            return Observable<VideoResult>.empty()
        }
        
        return buildRequest(urlRequest: urlRequest).map { _, data in
            try JSONDecoder().decode(VideoResult.self, from: data)
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
    func getMovieCredits(id: Int) -> Observable<MovieCreditResponse> {
        guard let urlRequest = Router.getMovieCredits(id: id, language: Locale.preferredLanguages[0]).urlRequest else {
            return Observable<MovieCreditResponse>.empty()
        }
        
        return buildRequest(urlRequest: urlRequest).map { _response, data in
            try JSONDecoder().decode(MovieCreditResponse.self, from: data)
        }
    }
    
    /** Used to get the list of official genres for movies.
    - Parameters:
        - completion: Invoked when request failed or completed.
        - success: Boolean value that returns true if api response is successful.
        - message: A string value that returns error message if any error occurs.
        - genres: 'Genres' object that contains all genres for movies.
     */
    func getGenres() -> Observable<Genres> {
        guard let urlRequest = Router.getGenres(language: Locale.preferredLanguages[0]).urlRequest else {
            return Observable<Genres>.empty()
        }
        
        return buildRequest(urlRequest: urlRequest).map { _, data in
            try JSONDecoder().decode(Genres.self, from: data)
        }
    }
}
