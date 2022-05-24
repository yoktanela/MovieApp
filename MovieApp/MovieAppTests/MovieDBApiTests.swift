//
//  MovieDBApiTests.swift
//  MovieAppTests
//
//  Created by Elanur Yoktan on 19.07.2021.
//

import XCTest
import RxSwift
import RxCocoa

@testable import MovieApp

class MovieDBApiTests: XCTestCase {
    
    private var apiService: APIService!
    private var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        apiService = APIService()
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        apiService = nil
        disposeBag = nil
        super.tearDown()
    }
    
    // MARK: Tests for getPopularMovies
    func test_getMovies() {
        let moviesExpectation = expectation(description: "movies")
        var movies: [Movie]?
        
        apiService.getPopularMovies()
            .subscribe(onNext: { movieList in
                movies = movieList
                moviesExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1)
        XCTAssertNotNil(movies)
    }
    
    func test_getMovies_shouldReturnError() {
        let moviesExpectation = expectation(description: "movies")
        var errorResponse: Error?
        
        apiService.getPopularMovies(page: 1000)
            .subscribe(onError: { error in
                errorResponse = error
                moviesExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1)
        XCTAssertNotNil(errorResponse)
    }
    
    // MARK: Tests for getMovie
    func test_getMovie() {
        var movieResponse: Movie?
        let movieExpectation = expectation(description: "movie")
        let movieId = 121
        
        apiService.getMovie(id: movieId)
            .subscribe(onNext: { movie in
                movieResponse = movie
                movieExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1)
        XCTAssertNotNil(movieResponse)
    }
    
    func test_getMovie_shouldReturnError() {
        var errorResponse: Error?
        let movieExpectation = expectation(description: "movie")
        let movieId = 100000
        
        apiService.getMovie(id: movieId)
            .subscribe(onError: { error in
                errorResponse = error
                movieExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1)
        XCTAssertNotNil(errorResponse)
    }
    
    // MARK: Tests for getPerson
    func test_getPerson() {
        var personResponse: Person?
        let personExpectation = expectation(description: "person")
        let personId = 113
        
        apiService.getPerson(id: personId)
            .subscribe(onNext: { person in
                personResponse = person
                personExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1)
        XCTAssertNotNil(personResponse)
    }
    
    func test_getPerson_shouldReturnError() {
        var errorResponse: Error?
        let personExpectation = expectation(description: "person")
        let personId = 1000000
        
        apiService.getPerson(id: personId)
            .subscribe(onError: { error in
                errorResponse = error
                personExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1)
        XCTAssertNotNil(errorResponse)
    }
    
    // MARK: Tests for getSearchResults
    func test_getSearchResults() throws {
        var movies: [Movie]?
        var persons: [Person]?
        let searchExpectation = expectation(description: "search")
        let searchText = "lotr"
        
        apiService.getSearchResults(searchText: searchText)
            .subscribe(onNext: { searchResult in
                movies = searchResult.movies
                persons = searchResult.persons
                searchExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1)
        XCTAssertTrue(movies != nil && persons != nil)
    }
    
    func test_getSearchResults_shouldReturnError() {
        var movies: [Movie]?
        var persons: [Person]?
        let searchExpectation = expectation(description: "search")
        let searchText = "asdjnbjmnks"
        
        apiService.getSearchResults(searchText: searchText)
            .subscribe(onNext: { searchResult in
                movies = searchResult.movies
                persons = searchResult.persons
                searchExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1)
        XCTAssertTrue(movies?.count == 0 && persons?.count == 0)
    }
    
    // MARK: Tests for getCast
    func test_getCast() throws {
        var cast: Cast?
        let castExpectation = expectation(description: "cast")
        let movieId = 121
        
        apiService.getCast(id: movieId)
            .subscribe(onNext: { result in
                cast = result
                castExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1)
        XCTAssertNotNil(cast)
    }
    
    func test_getCast_shouldReturnError() {
        var errorResponse: Error?
        let castExpectation = expectation(description: "cast")
        let movieId = 100000
        
        apiService.getCast(id: movieId)
            .subscribe(onError: { error in
                errorResponse = error
                castExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1)
        XCTAssertNotNil(errorResponse)
    }
    
    // MARK: Tests for getVideos
    func test_getVideos() {
        var videoResult: VideoResult?
        let videoExpectation = expectation(description: "video")
        let movieId = 121
        
        apiService.getVideos(id: movieId)
            .subscribe(onNext: { video in
                videoResult = video
                videoExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1)
        XCTAssertNotNil(videoResult)
    }
    
    func test_getVideos_shouldReturnError() {
        let videoExpectation = expectation(description: "video")
        var errorResponse: Error?
        let movieId = 100000
        
        apiService.getVideos(id: movieId)
            .subscribe(onError: { error in
                errorResponse = error
                videoExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1)
        XCTAssertNotNil(errorResponse)
    }
    
    // MARK: Tests for getMovieCredits
    func test_getMovieCredits() {
        var movies: MovieCreditResponse?
        let moviesExpectation = expectation(description: "movie_credits")
        let personId = 113
        
        apiService.getMovieCredits(id: personId)
            .subscribe(onNext: { result in
                movies = result
                moviesExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1)
        XCTAssertNotNil(movies)
    }
    
    func test_getMovieCredits_shouldReturnError() {
        let moviesExpectation = expectation(description: "movie_credits")
        var errorResponse: Error?
        let personId = 1000000
        
        apiService.getMovieCredits(id: personId)
            .subscribe(onError: { error in
                errorResponse = error
                moviesExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1)
        XCTAssertNotNil(errorResponse)
    }
    
    // MARK: Tests for getGenres
    func test_getGenres() throws {
        var genres: Genres?
        let genresExpectation = expectation(description: "genres")
        
        apiService.getGenres()
            .subscribe(onNext: { result in
                genres = result
                genresExpectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1)
        XCTAssertNotNil(genres)
    }
}
