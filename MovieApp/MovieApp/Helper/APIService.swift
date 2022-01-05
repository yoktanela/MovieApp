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
    
    enum ApiError: Error {
      case serverFailure
      case invalidKey
    }
    
    let disposeBag = DisposeBag()
    
    override init() {
        super.init()
    }
    
    // Generic function to get and parse api response
    private func buildRequest<T:Decodable>(urlRequest: URLRequest) -> Observable<T> {
        let response = URLSession.shared.rx.response(request: urlRequest)
        
        return response.map { response, data -> T in
          switch response.statusCode {
          case 200 ..< 300:
            return try JSONDecoder().decode(T.self, from: data)
          case 401:
            throw ApiError.invalidKey
          default:
            throw ApiError.serverFailure
          }
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
        
        let response: Observable<MoviesResponse> = buildRequest(urlRequest: urlRequest)
        
        return Observable<[Movie]>.create { observer in
            response.subscribe { movieResponse in
                observer.onNext(movieResponse.results)
            } onError: { error in
                observer.onError(error)
            } onCompleted: {
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    func getMovie(id: Int) -> Observable<Movie> {
        guard let urlRequest = Router.getMovie(id: id, language: Locale.preferredLanguages[0]).urlRequest else {
            return Observable<Movie>.empty()
        }
        
        return buildRequest(urlRequest: urlRequest) as Observable<Movie>
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
        
        return buildRequest(urlRequest: urlRequest) as Observable<Person>
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
        
        let response: Observable<MediaResponse> = buildRequest(urlRequest: urlRequest)
        
        return Observable<(movies: [Movie], persons: [Person])>.create { observer in
            response.subscribe { mediaResponse in
                var movies: [Movie] = []
                var persons: [Person] = []
                mediaResponse.results.map({ media in
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
                observer.onNext((movies: movies, persons: persons))
            } onError: { error in
                observer.onError(error)
            } onCompleted: {
                observer.onCompleted()
            }
            return Disposables.create()
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
        
        return buildRequest(urlRequest: urlRequest) as Observable<Cast>
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
        
        return buildRequest(urlRequest: urlRequest) as Observable<VideoResult>
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
        
        return buildRequest(urlRequest: urlRequest) as Observable<MovieCreditResponse>
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
        
        return buildRequest(urlRequest: urlRequest) as Observable<Genres>
    }
}
